import dotenv from "dotenv";
dotenv.config();
import express from "express";
import cors from "cors";
const app = express();
import bodyParser from "body-parser";
import { fetchTrafficAndWeather } from "./utils/weather-traffic.js";
import admin from "./utils/firebase.js";
import { promises as fsPromises } from "fs";

app.use(cors());
app.use(express.json());

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/test", (req, res) => {
  return res.json(`Hello! Testing the Two Wheeler Service API`);
});

app.post("/hybrid", (req, res) => {
  const latitude = req.body.latitude;
  const longitude = req.body.longitude;
  console.log(longitude, latitude);
  fetchTrafficAndWeather(latitude, longitude)
    .then((data) => {
      const pushedDataRef = admin.database().ref("hybrid-server-test").push();
      pushedDataRef
        .set(data)
        .then(() => {
          res.status(200).send("Data pushed successfully");
        })
        .catch((error) => {
          res.status(500).send("Error pushing data:" + error);
        });
    })
    .catch((error) => {
      res.status(500).send("Error:" + error);
    });
});

app.get("/testserver", (req, res) => {
  const {
    lat,
    lon,
    refName,
    anomaly,
    accX,
    accY,
    accZ,
    gyroX,
    gyroY,
    gyroZ,
    roll,
    pitch,
    yaw,
  } = req.query;
  const sensorData = {
    anomaly: anomaly || false,
    accX: accX || 0,
    accY: accY || 0,
    accZ: accZ || 0,
    gyroX: gyroX || 0,
    gyroY: gyroY || 0,
    gyroZ: gyroZ || 0,
    roll: roll || 0,
    pitch: pitch || 0,
    yaw: yaw || 0,
  };
  console.log(lat, lon);
  const currentDate = new Date();
  const day = currentDate.getDate(); // Get the day of the month (1-31)
  const month = currentDate.getMonth() + 1; // Get the month (0-11) and add 1 to adjust to (1-12)
  const year = currentDate.getFullYear();
  const date = `${day}-${month}-${year}`
  console.log(date)
  fetchTrafficAndWeather(lat, lon)
    .then((data) => {
      const pushedTrafficWeatherDataRef = admin
        .database()
        .ref("server/day-Japneet/" + refName + "/"+date)
        .push();
      const sensorAndTrafficWeatherData = {
        ...sensorData,
        ...data,
      };

      pushedTrafficWeatherDataRef
        .set(sensorAndTrafficWeatherData)
        .then(() => {
          res.status(200).send("Data pushed successfully");
        })
        .catch((error) => {
          res.status(500).send("Error pushing data:" + error);
        });
    })
    .catch((error) => {
      res.status(500).send("Error:" + error);
    });
});

app.get("/testserverCSV", (req, res) => {
  const { lat, lon, accX, accY, accZ, gyroX, gyroY, gyroZ, roll, pitch, yaw } =
    req.query;
  const sensorData = {
    accX: accX || 0,
    accY: accY || 0,
    accZ: accZ || 0,
    gyroX: gyroX || 0,
    gyroY: gyroY || 0,
    gyroZ: gyroZ || 0,
    roll: roll || 0,
    pitch: pitch || 0,
    yaw: yaw || 0,
  };
  console.log(lat, lon);
  fetchTrafficAndWeather(lat, lon)
    .then((data) => {
      const sensorAndTrafficWeatherData = {
        ...sensorData,
        ...data,
      };

      // Store data in CSV file
      writeToCSV(sensorAndTrafficWeatherData)
        .then(() => {
          res.status(200).send("Data stored in CSV successfully");
        })
        .catch((error) => {
          res.status(500).send("Error storing data in CSV:" + error);
        });
    })
    .catch((error) => {
      res.status(500).send("Error:" + error);
    });
});

app.get("/downloadCSV", async (req, res) => {
  const filePath = "data.csv";

  // Set the response headers to indicate a downloadable file
  res.setHeader("Content-Disposition", `attachment; filename=${filePath}`);
  res.setHeader("Content-Type", "text/csv");

  try {
    const fileContent = await fsPromises.readFile(filePath, "utf-8");
    res.send(fileContent);
  } catch (error) {
    res.status(500).send("Error:" + error);
  }
});

// Function to write data to CSV file
async function writeToCSV(data) {
  const csvFilePath = "data.csv";

  // Convert data to CSV format
  const csvData = Object.values(data).join(",") + "\n";

  // Append data to CSV file
  await fsPromises.appendFile(csvFilePath, csvData);
}

app.post("/server", (req, res) => {
  const sensorData = req.body;
  fetchTrafficAndWeather(sensorData.latitude, sensorData.longitude)
    .then((data) => {
      const pushedTrafficWeatherDataRef = admin
        .database()
        .ref("server/day-0/careful")
        .push();
      const sensorAndTrafficWeatherData = {
        ...sensorData,
        ...data,
      };
      pushedTrafficWeatherDataRef
        .set(sensorAndTrafficWeatherData)
        .then(() => {
          res.status(200).send("Data pushed successfully");
        })
        .catch((error) => {
          res.status(500).send("Error pushing data:" + error);
        });
    })
    .catch((error) => {
      res.status(500).send("Error:" + error);
    });
});

app.get("/countDocuments", (req, res) => {
  const { refName } =
    req.query;
  const refPath = "server/day-Japneet/"+refName; // Adjust this to your specific path

  // Use once method to fetch the data at the reference
  admin
    .database()
    .ref(refPath)
    .once("value")
    .then((snapshot) => {
      if (snapshot.exists()) {
        // Count the number of children (documents) in the reference
        const numberOfDocuments = snapshot.numChildren();
        res.status(200).json({ count: numberOfDocuments });
      } else {
        res.status(404).send(`Reference ${refPath} not found or has no data.`);
      }
    })
    .catch((error) => {
      res.status(500).send("Error fetching data:" + error);
    });
});

// Endpoint to count the number of lines in data.csv
app.get("/countLines", async (req, res) => {
  try {
    const lineCount = await countLines("data.csv");
    res.status(200).json({ count: lineCount });
  } catch (error) {
    res.status(500).send("Error:" + error);
  }
});

// Function to count the number of lines in a file
async function countLines(filePath) {
  const content = await fsPromises.readFile(filePath, "utf-8");
  const lines = content.split("\n");
  return lines.length - 1; // Subtract 1 to exclude the empty line at the end
}

// Start the server
const PORT = 3001;
app.listen(PORT, () => {
  console.log("Server listening on port " + PORT + "...");
});
