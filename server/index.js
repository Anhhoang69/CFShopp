import express from 'express'; // ES module syntax
import connectToSystemDatabase from './config/db.js'; // Database connection logic
import dotenv from 'dotenv'; // To load environment variables
import cors from 'cors'; // For handling CORS
import sql from 'mssql'; 

// Load environment variables from .env file
dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

// Middleware to parse JSON requests and enable CORS
app.use(express.json());
app.use(cors()); // Enable CORS

app.get('/', async (req, res) => {
  try {
    const pool = await connectToSystemDatabase(); // Kết nối tới DB
    const result = await pool.request().query('SELECT @@VERSION AS version'); // Truy vấn kiểm tra

    res.status(200).json({
      message: 'Connected to the database successfully!',
      sqlServerVersion: result.recordset[0].version
    });

    pool.close(); // Đóng kết nối sau khi xong
  } catch (error) {
    res.status(500).json({
      message: 'Failed to connect to the database',
      error: error.message
    });
  }
});

// API endpoint để lấy thông tin nhân viên theo ShopID
app.get('/employees/:shopID', async (req, res) => {
  const { shopID } = req.params;

  try {
    const pool = await connectToSystemDatabase();
    
    // Gọi thủ tục GetEmployeesByShopID
    const result = await pool.request()
      .input('ShopID', sql.Char(5), shopID) // Truyền tham số vào thủ tục
      .execute('GetEmployeesByShopID'); // Thực thi thủ tục

    // Trả kết quả ra API
    res.status(200).json(result.recordset);
    pool.close();
  } catch (err) {
    console.error('Error executing stored procedure:', err.message);
    res.status(500).json({ error: 'Failed to retrieve employees.' });
  }
});

// API thêm nhân viên
app.post('/add-employee', async (req, res) => {
  const {
      empID,
      empStartDate,
      empName,
      empPhoneNumber,
      empSsn,
      bdate,
      empAccount,
      empType,
      empSex,
      empAddress,
      hourSalary,
      empStatus,
      supervisorID,
      empshopID,
      empEmails,
      delLicense,
      serPosition,
  } = req.body;

  // Kiểm tra dữ liệu đầu vào cơ bản
  if (!empID || empID.length !== 8) {
      return res.status(400).json({ error: 'ID nhân viên phải có đúng 8 ký tự.' });
  }
  if (!empStartDate || !empName || !empPhoneNumber || !empSsn || !bdate || !empAccount || !empType || !empSex || !empAddress || !hourSalary || !empStatus || !empshopID || !empEmails) {
      return res.status(400).json({ error: 'Vui lòng cung cấp đầy đủ thông tin bắt buộc.' });
  }

  try {
      const pool = await connectToSystemDatabase();

      // Gọi thủ tục InsertEmployee
      const result = await pool.request()
          .input('empID', sql.Char(8), empID)
          .input('empStartDate', sql.Date, empStartDate)
          .input('empName', sql.NVarChar(25), empName)
          .input('empPhoneNumber', sql.Char(10), empPhoneNumber)
          .input('empSsn', sql.Char(12), empSsn)
          .input('bdate', sql.Date, bdate)
          .input('empAccount', sql.NVarChar(70), empAccount)
          .input('empType', sql.NVarChar(20), empType)
          .input('empSex', sql.Char(1), empSex)
          .input('empAddress', sql.NVarChar(50), empAddress)
          .input('hourSalary', sql.Int, hourSalary)
          .input('empStatus', sql.VarChar(30), empStatus)
          .input('supervisorID', sql.Char(8), supervisorID || null) // Null nếu không có supervisorID
          .input('empshopID', sql.Char(5), empshopID)
          .input('empEmails', sql.VarChar(sql.MAX), empEmails)
          .input('delLicense', sql.VarChar(12), delLicense || null) // Null nếu không phải nhân viên giao hàng
          .input('serPosition', sql.NVarChar(20), serPosition || null) // Null nếu không phải nhân viên phục vụ
          .execute('InsertEmployee');

      // Trả về thông báo thành công
      res.status(200).json({ message: 'Thêm nhân viên thành công.' });
  } catch (err) {
      console.error('Error inserting employee:', err);

      // Xử lý lỗi trả về từ thủ tục
      if (err.number === 50000) {
          res.status(400).json({ error: 'ID nhân viên phải có 8 ký tự.' });
      } else if (err.number === 50001) {
          res.status(400).json({ error: 'ID nhân viên đã tồn tại.' });
      } else if (err.number === 50002) {
          res.status(400).json({ error: 'Số điện thoại không hợp lệ, phải có 10 chữ số.' });
      } else if (err.number === 50003) {
          res.status(400).json({ error: 'Số CCCD đã tồn tại.' });
      } else if (err.number === 50004) {
          res.status(400).json({ error: 'Ngày sinh không thể lớn hơn ngày hiện tại.' });
      } else if (err.number === 50005) {
          res.status(400).json({ error: 'Lương theo giờ phải lớn hơn 0.' });
      } else if (err.number === 50007) {
          res.status(400).json({ error: 'Giới tính không hợp lệ. Phải là M hoặc F.' });
      } else if (err.number === 50008) {
          res.status(400).json({ error: 'Mã cửa hàng không hợp lệ.' });
      } else if (err.number === 50010) {
          res.status(400).json({ error: 'Trạng thái nhân viên không hợp lệ. Phải là Active, Inactive, On Leave hoặc Suspended.' });
      } else if (err.number === 50011) {
          res.status(400).json({ error: 'Mã quản lý không tồn tại hoặc không phải là nhân viên loại "Quản lý".' });
      } else if (err.number === 50019) {
          res.status(400).json({ error: 'Địa chỉ email không hợp lệ.' });
      } else if (err.number === 50020) {
          res.status(400).json({ error: 'Giấy phép giao hàng là bắt buộc đối với nhân viên giao hàng.' });
      } else if (err.number === 50021) {
          res.status(400).json({ error: 'Vị trí phục vụ là bắt buộc đối với nhân viên phục vụ.' });
      } else {
          res.status(500).json({ error: 'Có lỗi xảy ra khi thêm nhân viên.', details: err.message });
      }
  }
});

// API để gọi thủ tục UpdateEmployee
app.post('/update-employee', async (req, res) => {
  const {
      empID,
      empName,
      empPhoneNumber,
      empAddress,
      hourSalary,
      empStatus,
      empSex,
      bdate,
      empAccount,
      empType,
      supervisorID,
      empshopID,
      empEmails,
      delLicense,
      serPosition
  } = req.body;

  try {
      // Kết nối với SQL Server
      const pool = await connectToSystemDatabase();

      // Gọi thủ tục UpdateEmployee
      const result = await pool.request()
          .input('empID', sql.Char(8), empID)
          .input('empName', sql.NVarChar(25), empName || null)
          .input('empPhoneNumber', sql.Char(10), empPhoneNumber || null)
          .input('empAddress', sql.NVarChar(50), empAddress || null)
          .input('hourSalary', sql.Int, hourSalary || null)
          .input('empStatus', sql.VarChar(30), empStatus || null)
          .input('empSex', sql.Char(1), empSex || null)
          .input('bdate', sql.Date, bdate || null)
          .input('empAccount', sql.NVarChar(70), empAccount || null)
          .input('empType', sql.NVarChar(20), empType || null)
          .input('supervisorID', sql.Char(8), supervisorID || null)
          .input('empshopID', sql.Char(5), empshopID || null)
          .input('empEmails', sql.VarChar(sql.MAX), empEmails || null)
          .input('delLicense', sql.VarChar(12), delLicense || null)
          .input('serPosition', sql.NVarChar(20), serPosition || null)
          .execute('UpdateEmployee');

      // Trả về kết quả thành công
      res.status(200).json({ message: 'Cập nhật nhân viên thành công!' });

  } catch (error) {
      console.error('Error updating employee:', error);

      // Xử lý lỗi trả về từ thủ tục
      if (error.number === 50000) {
          res.status(400).json({ error: 'ID nhân viên phải có đúng 8 ký tự.' });
      } else if (error.number === 50003) {
          res.status(400).json({ error: 'ID nhân viên không tồn tại.' });
      } else if (error.number === 50002) {
          res.status(400).json({ error: 'Số điện thoại phải có đúng 10 chữ số.' });
      } else if (error.number === 50004) {
          res.status(400).json({ error: 'Lương phải lớn hơn 0.' });
      } else if (error.number === 50010) {
          res.status(400).json({ error: 'Trạng thái nhân viên không hợp lệ.' });
      } else if (error.number === 50005) {
          res.status(400).json({ error: 'Giới tính không hợp lệ. Phải là M hoặc F.' });
      } else if (error.number === 50006) {
          res.status(400).json({ error: 'Ngày sinh không thể lớn hơn ngày hiện tại.' });
      } else if (error.number === 50009) {
          res.status(400).json({ error: 'Mã cửa hàng không tồn tại.' });
      } else if (error.number === 50011) {
          res.status(400).json({ error: 'Mã quản lý không tồn tại.' });
      } else if (error.number === 50012) {
          res.status(400).json({ error: 'Không có thông tin nào được cập nhật.' });
      } else if (error.number === 50019) {
          res.status(400).json({ error: 'Địa chỉ email không hợp lệ.' });
      } else if (error.number === 50020) {
          res.status(400).json({ error: 'Giấy phép giao hàng là bắt buộc đối với nhân viên giao hàng.' });
      } else if (error.number === 50021) {
          res.status(400).json({ error: 'Vị trí phục vụ là bắt buộc đối với nhân viên phục vụ.' });
      } else {
          res.status(500).json({ error: 'Có lỗi xảy ra khi cập nhật nhân viên.', details: error.message });
      }
  }
});

// API xóa nhân viên theo empID
app.delete('/delete-employee', async (req, res) => {
  const { empID } = req.body;

  if (!empID || empID.trim().length !== 8) {
    return res.status(400).json({ error: 'Mã nhân viên phải có đúng 8 ký tự.' });
  }

  try {
    const pool = await connectToSystemDatabase();

    await pool.request()
      .input('empID', sql.Char(8), empID.trim()) // Sử dụng trim để loại bỏ khoảng trắng
      .execute('DeleteEmployee');

    res.status(200).json({ message: 'Xóa nhân viên thành công!' });
  } catch (err) {
    console.error('Error:', err);

    // Kiểm tra mã lỗi từ SQL Server và phản hồi tương ứng
    if (err.number === 50010) {
      res.status(400).json({ error: 'Không thể xóa nhân viên vì họ đang phụ trách đơn hàng.' });
    } else if (err.number === 50009) {
      res.status(400).json({ error: 'Không thể xóa nhân viên quản lý.' });
    } 
    else if (err.number === 50011) {
      res.status(400).json({ error: 'Không thể xóa nhân viên vì họ đang liên quan đến phản hồi khách hàng.' });
    } else if (err.number === 50012) {
      res.status(400).json({ error: 'Không thể xóa nhân viên vì họ đang liên quan đến hóa đơn.' });
    } else if (err.number === 50005) {
      res.status(404).json({ error: 'Không tìm thấy nhân viên với mã đã nhập.' });
    } else {
      res.status(500).json({ error: 'Có lỗi xảy ra khi xóa nhân viên.', details: err.message });
    }
  }
});
// API endpoint để tính lương nhân viên theo ShopID và khoảng thời gian
app.post('/calculate-salaries', async (req, res) => {
  const { shopID, startDate, endDate } = req.body;

  // Kiểm tra tham số đầu vào
  if (!shopID || !startDate || !endDate) {
    return res.status(400).json({ error: 'Missing required parameters' });
  }

  try {
    // Kết nối đến database
    const pool = await connectToSystemDatabase();

    // Gọi table-valued function CalculateEmployeeSalariesByShop
    const result = await pool.request()
      .input('ShopID', sql.Char(5), shopID)
      .input('StartDate', sql.Date, startDate)
      .input('EndDate', sql.Date, endDate)
      .query(`
        SELECT * 
        FROM dbo.CalculateEmployeeSalariesByShop(@ShopID, @StartDate, @EndDate)
      `); // Thực thi hàm Table-Valued Function và trả về kết quả

    // Trả kết quả tính lương
    res.status(200).json(result.recordset); // Trả về kết quả của bảng SalaryReport
    pool.close();
  } catch (err) {
    console.error('Error executing table-valued function:', err.message);  // Ghi lỗi chi tiết
    res.status(500).json({ error: 'Failed to calculate salaries', details: err.message }); // Trả về lỗi chi tiết
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
