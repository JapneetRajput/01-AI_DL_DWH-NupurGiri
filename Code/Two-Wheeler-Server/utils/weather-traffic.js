import Axios from "axios";
import { parseString } from "xml2js";

// const TOMTOM_API_KEY = "2uS1WV1KTs53bGxKf7GSiwHvq7KWtoiy";
// const Traffic_API_URL = `https://api.tomtom.com/traffic/services/4/flowSegmentData/absolute/10/xml?key=${TOMTOM_API_KEY}`;
const INCIDENTS_API_URL =
  "https://api.tomtom.com/traffic/services/5/incidentDetails";
const OPENWEATHERMAP_API_URL =
  "https://api.openweathermap.org/data/2.5/weather";

function roadTypeDescription(frc) {
  switch (frc) {
    case "FRC0":
      return "Motorway, freeway, or other major road";
    case "FRC1":
      return "Major road, less important than a motorway";
    case "FRC2":
      return "Other major road";
    case "FRC3":
      return "Secondary road";
    case "FRC4":
      return "Local connecting road";
    case "FRC5":
      return "Local road of high importance";
    case "FRC6":
      return "Local road";
    default:
      return "Unknown road type";
  }
}

function classifyTrafficIntensity(congestionIndex, travelTimeIndex) {
  const trafficIntensityIndex = (congestionIndex + travelTimeIndex) / 2;

  if (trafficIntensityIndex <= 0.2) {
    return "Low traffic intensity (light traffic)";
  } else if (trafficIntensityIndex <= 0.4) {
    return "Moderate traffic intensity";
  } else if (trafficIntensityIndex <= 0.6) {
    return "High traffic intensity (heavy traffic)";
  } else {
    return "Severe traffic intensity (standstill or very slow traffic)";
  }
}

function classifyWeatherIntensity(apiData) {
  const visibility = apiData.visibility || 0;
  const temperature = apiData.main.temp || 0;
  const cloudiness = apiData.clouds.all;
  const humidity = apiData.main.humidity || 0;
  const windSpeed = apiData.wind.speed || 0;
  const weatherDescription = apiData.weather[0].description || "";

  let weatherConditionValue = 0;

  if (weatherDescription.includes("rain")) {
    weatherConditionValue = 1;
  } else if (weatherDescription.includes("shower rain")) {
    weatherConditionValue = 0.7;
  } else if (weatherDescription.includes("thunderstorm")) {
    weatherConditionValue = 1;
  } else if (weatherDescription.includes("snow")) {
    weatherConditionValue = 1;
  } else if (weatherDescription.includes("mist")) {
    weatherConditionValue = 0.5;
  }

  const weights = {
    visibility: -0.2,
    temperature: -0.05,
    humidity: 0.1,
    windSpeed: 0.1,
    cloudiness: 0.1,
    weatherDescription: weatherConditionValue,
  };

  const weatherIntensity =
    weights.visibility * visibility +
    weights.temperature * temperature +
    weights.humidity * humidity +
    weights.windSpeed * windSpeed +
    weights.cloudiness * cloudiness +
    weights.weatherDescription;

  if (weatherIntensity < 0.33) {
    return "Low";
  } else if (weatherIntensity < 0.66) {
    return "Medium";
  } else {
    return "High";
  }
}

const TOMTOM_API_KEYS = [
  "dvcANZyhVyYHGjLPG4ztKj35T3E8tRwS", // Japneet 3
  "55Hwu3grmhll6ZpY7KmXowJNnWX91ME0", // Harsh
  "Ba8HjhkZ454sTwLrjoeQScZulN5gC98g", // Aditya
  "qbegtDSYY8vKg6BJOYUNMNDHxykuJIjp", // Sejal
  "aUmxQiILPk2yEg6YBLStiShGDwHor2X4", // Digvijay
  "KqrucFhnJDfOL0TgRTLsUXi4c3tyrZHk", // Sania
  "CgCRZjeVMcMUCdMWR4JSS1GSmPaBgwLU", // Simran
  "2uS1WV1KTs53bGxKf7GSiwHvq7KWtoiy", // Japneet 1
  "UeE3WSoJ2oxLWN1qIPGzoeiDGgIXxAVw", // Tanmay
  "wEtT7leXaXmhjOmc8uo6HEKDa3zEe34G", // Vishakha
  "YAWuU5s6DylWigj4DnQ1nY0lPsiZKwRZ", // Anish
  "swUDbmXyfWzuXA9i9pyFpoUQTagznTKQ", // Jessica
  "83dSBME9SP79a0IXMhCJTQGbytW0e2dw", // Yashvi
  "JmIlmJjY86UM16jD7ldTbDKhPWfGJeDF", // Anurag
  "RmpMprlmy2pC1MnjFOrngH9YA5x6rU50", // Nilesh
  "eWJeC3lOVp2cSa00GiHGQUlHY6cI6FBZ", // Japneet 2
];

let currentApiKeyIndex = 0;

async function makeTrafficApiRequest(latitude, longitude) {
  try {
    const apiKey = TOMTOM_API_KEYS[currentApiKeyIndex];
    const Traffic_API_URL = `https://api.tomtom.com/traffic/services/4/flowSegmentData/absolute/10/xml?key=${apiKey}`;

    const params = { point: `${latitude},${longitude}` };

    // Make the API request to TomTom Traffic Services
    const response = await Axios.get(Traffic_API_URL, { params });

    if (response.status === 200) {
      const apiData = response.data;
      let parsedData;
      parseString(apiData, (err, result) => {
        if (err) throw err;
        parsedData = result;
      });

      // Extract required data from parsed XML (replace these lines with your logic)
      const currentSpeed = parseInt(parsedData.flowSegmentData.currentSpeed[0]);
      const freeFlowSpeed = parseInt(
        parsedData.flowSegmentData.freeFlowSpeed[0]
      );
      const currentTravelTime = parseInt(
        parsedData.flowSegmentData.currentTravelTime[0]
      );
      const freeFlowTravelTime = parseInt(
        parsedData.flowSegmentData.freeFlowTravelTime[0]
      );
      const roadClosure = parsedData.flowSegmentData.roadClosure[0];
      const congestionIndex = (freeFlowSpeed - currentSpeed) / freeFlowSpeed;
      const travelTimeIndex =
        (currentTravelTime - freeFlowTravelTime) / freeFlowTravelTime;
      const trafficIntensity = classifyTrafficIntensity(
        congestionIndex,
        travelTimeIndex
      );
      const roadTypeDescriptionValue = roadTypeDescription(
        parsedData.flowSegmentData.frc[0]
      );

      return {
        Latitude: latitude,
        Longitude: longitude,
        currentSpeed,
        freeFlowSpeed,
        currentTravelTime,
        freeFlowTravelTime,
        trafficIntensity: trafficIntensity || null,
        roadClosure: roadClosure || null,
        roadTypeDescription: roadTypeDescriptionValue,
        APIResponse: apiData,
      };
    }
  } catch (error) {
    console.error(error);

    // Handle rate limit exceeded
    if (error.response && error.response.status === 403) {
      // Move to the next API key
      currentApiKeyIndex = (currentApiKeyIndex + 1) % TOMTOM_API_KEYS.length;
      console.log(
        `Switching to the next API key tom: ${TOMTOM_API_KEYS[currentApiKeyIndex]}`
      );

      // Retry with the next API key
      return makeTrafficApiRequest(latitude, longitude);
    }

    return {
      Latitude: latitude,
      Longitude: longitude,
      APIResponse: "null",
      currentSpeed: "null",
      freeFlowSpeed: "null",
      currentTravelTime: "null",
      freeFlowTravelTime: "null",
      TrafficIntensity: "null",
      roadTypeDescription: "null",
    };
  }
}

const OPENWEATHERMAP_API_KEY = [
  "44a9f2a8c47cca6a871c09ffa33f0111",
  "2ede55ef7dde3279816bf7a2b586a683",
  "0abe0d0f7d354073638c4e324a5a97e2",
  "70366fd27d81032eb6dcc4214a1135f0",
  "8da736c197043358b1198551305f5487",
];

let currentWeatherApiKeyIndex = 0;

async function makeWeatherApiRequestAndSave(latitude, longitude, refName) {
  try {
    let params = {};
    if (refName == "fluttertanmay" || refName == "tanmay") {
      params = {
        lat: latitude,
        lon: longitude,
        appid:
          OPENWEATHERMAP_API_KEY[
            currentWeatherApiKeyIndex % OPENWEATHERMAP_API_KEY.length
          ],
        units: "metric",
      };
    } else {
      params = {
        lat: latitude,
        lon: longitude,
        appid:
          OPENWEATHERMAP_API_KEY[
            currentWeatherApiKeyIndex % OPENWEATHERMAP_API_KEY.length
          ],
        units: "metric",
      };
    }

    const response = await Axios.get(OPENWEATHERMAP_API_URL, { params });

    if (response.status === 200) {
      const apiData = response.data;

      const temperature = apiData.main.temp;
      const weatherDescription = apiData.weather[0].description;
      const humidity = apiData.main.humidity;
      const windSpeed = apiData.wind.speed;
      const visibility = apiData.visibility;
      const cloudiness = apiData.clouds.all;
      const weatherIntensity = classifyWeatherIntensity(apiData);

      return {
        latitude,
        longitude,
        api_data: apiData,
        temperature,
        humidity,
        wind_speed: windSpeed,
        visibility,
        cloudiness,
        weather_description: weatherDescription,
        weather_intensity: weatherIntensity,
      };
    } else {
      console.error(`Error making API request weather: ${error.message}`);
      if (error.response && error.response.status === 429) {
        // Rate limit exceeded, switch to the next API key
        currentWeatherApiKeyIndex =
          (currentWeatherApiKeyIndex + 1) % OPENWEATHERMAP_API_KEY.length;
        console.log(
          `Switching to the next API key weather: ${OPENWEATHERMAP_API_KEY[currentWeatherApiKeyIndex]}`
        );
        // Retry with the next API key
        return makeWeatherApiRequestAndSave(latitude, longitude, refName);
      }
      return { error: "Failed to fetch data" };
    }
  } catch (error) {
    console.error(`Error making API request weather: ${error.message}`);
    if (error.response && error.response.status === 429) {
      // Rate limit exceeded, switch to the next API key
      currentWeatherApiKeyIndex =
        (currentWeatherApiKeyIndex + 1) % OPENWEATHERMAP_API_KEY.length;
      console.log(
        `Switching to the next API key: ${OPENWEATHERMAP_API_KEY[currentWeatherApiKeyIndex]}`
      );
      // Retry with the next API key
      return makeWeatherApiRequestAndSave(latitude, longitude, refName);
    }
    return { error: "Failed to fetch data" };
  }
}

export async function fetchTrafficAndWeather(latitude, longitude, refName) {
  const trafficData = await makeTrafficApiRequest(latitude, longitude);
  const weatherData = await makeWeatherApiRequestAndSave(
    latitude,
    longitude,
    refName
  );
  const unixTimestamp = Math.floor(Date.now() / 1000);

  // Convert the Unix timestamp to milliseconds
  const milliseconds = unixTimestamp * 1000;

  // Create a new Date object with the milliseconds
  const dateObject = new Date(milliseconds);

  // Extract the various components of the date
  const year = dateObject.getFullYear();
  const month = dateObject.getMonth() + 1; // Months are zero-based, so add 1
  const day = dateObject.getDate();
  const hours = dateObject.getHours();
  const minutes = dateObject.getMinutes();
  const seconds = dateObject.getSeconds();

  // Create a formatted date string
  const formattedDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;

  // Combine and structure data as needed
  const combinedData = {
    Latitude: latitude,
    Longitude: longitude,
    CurrentSpeed: trafficData.currentSpeed,
    FreeFlowSpeed: trafficData.freeFlowSpeed,
    CurrentTravelTime: trafficData.currentTravelTime,
    FreeFlowTravelTime: trafficData.freeFlowTravelTime,
    RoadTypeDescription: trafficData.roadTypeDescription,
    TrafficIntensity: trafficData.trafficIntensity | null,
    RoadClosure: trafficData.roadClosure | null,
    Temperature: weatherData.temperature,
    Humidity: weatherData.humidity,
    WindSpeed: weatherData.wind_speed,
    Visibility: weatherData.visibility,
    Cloudiness: weatherData.cloudiness,
    WeatherDescription: weatherData.weather_description,
    WeatherIntensity: weatherData.weather_intensity,
    Timestamp: formattedDate,
  };

  return combinedData;
}
