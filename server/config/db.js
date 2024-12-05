import dotenv from 'dotenv'; // Import dotenv to load environment variables
import sql from 'mssql'; // Import mssql for SQL Server interaction

dotenv.config(); // Load environment variables from .env file

const config = {
  server: process.env.DB_SERVER || 'localhost', // Default to localhost if not set in .env
  database: process.env.DB_DATABASE || 'master', // Default to 'master' if not set
  options: {
    encrypt: false, // Set to true if using Azure, false for local SQL Server
    trustServerCertificate: true, // For self-signed certificates (e.g., local server)
  },
  port: 1433, // Default SQL Server port (changed to 1433; 1443 is incorrect)
};

// Function to connect to the system database
async function connectToSystemDatabase() {
  try {
    const pool = await sql.connect(config); // Establish the connection
    console.log('Connected to the SQL Server system database.');
    return pool; // Return the pool for further use
  } catch (err) {
    console.error('Error connecting to the database:', err.message);
    throw err; // Throw the error to be handled elsewhere
  }
}

export default connectToSystemDatabase; // Export the function for use in other files
