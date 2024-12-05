import express from 'express'; // ES module syntax
import connectToSystemDatabase from './config/db.js'; // Database connection logic
import dotenv from 'dotenv'; // To load environment variables
import cors from 'cors'; // For handling CORS

// Load environment variables from .env file
dotenv.config();

const app = express();

// Middleware to parse JSON requests and enable CORS
app.use(express.json());
app.use(cors()); // Enable CORS

// Example route to fetch SQL Server version
app.get('/version', async (req, res) => {
  try {
    const pool = await connectToSystemDatabase();
    const result = await pool.request().query('SELECT @@VERSION AS Version');
    res.status(200).json({ version: result.recordset[0].Version });
    pool.close();
  } catch (err) {
    console.error('Error fetching version:', err.message);
    res.status(500).json({ error: 'Failed to retrieve version from SQL Server' });
  }
});

// Example route to list all databases
app.get('/databases', async (req, res) => {
  try {
    const pool = await connectToSystemDatabase();
    const result = await pool.request().query('SELECT name FROM sys.databases');
    res.status(200).json({ databases: result.recordset });
    pool.close();
  } catch (err) {
    console.error('Error fetching databases:', err.message);
    res.status(500).json({ error: 'Failed to retrieve databases from SQL Server' });
  }
});

// Start the server
const port = process.env.PORT || 6000;
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
