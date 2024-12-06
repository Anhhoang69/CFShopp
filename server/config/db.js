import dotenv from 'dotenv';
import sql from 'mssql';

dotenv.config(); // Nạp biến môi trường từ .env

const config = {
  server: process.env.DB_SERVER || 'localhost',
  database: process.env.DB_DATABASE || 'master',
  user: process.env.DB_USER,  // Lấy user từ .env
  password: process.env.DB_PASSWORD,  // Lấy password từ .env
  options: {
    encrypt: false,  // Set true nếu dùng Azure
    trustServerCertificate: true,  // Bỏ qua chứng chỉ tự ký
  },
  port: 1433,  // Cổng mặc định của SQL Server
};

// Hàm kết nối đến cơ sở dữ liệu
async function connectToSystemDatabase() {
  try {
    const pool = await sql.connect(config); // Thiết lập kết nối
    console.log('Connected to the SQL Server system database.');
    return pool; // Trả về pool để sử dụng tiếp
  } catch (err) {
    console.error('Error connecting to the database:', err.message);
    throw err; // Ném lỗi để xử lý ở nơi khác
  }
}

export default connectToSystemDatabase; // Xuất hàm kết nối
