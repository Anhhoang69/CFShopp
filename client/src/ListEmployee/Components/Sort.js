// Updated Sort.js
/* eslint-disable jsx-a11y/anchor-is-valid */
import React, { Component } from "react";

class Sort extends Component {
  constructor(props) {
    super(props);
    this.state = {
      sortby: "empID", // Mặc định sắp xếp theo empID
      sortvalue: 1, // 1: tăng dần, -1: giảm dần
    };
  }

  onSort = (sortBy, sortValue) => {
    this.setState(
      {
        sortby: sortBy,
        sortvalue: sortValue,
      },
      () => this.props.onSort(this.state.sortby, this.state.sortvalue)
    );
  };

  render() {
    return (
      <thead>
        <tr>
          <th className="text_center" width="50px">
            <button className="btn text_center">STT</button>
          </th>
          <th className="text_center">
            <div className="dropdown">
              <button
                type="button"
                className="btn dropdown-toggle"
                id="dropdownEmpID"
                data-toggle="dropdown"
                aria-haspopup="true"
                aria-expanded="true"
              >
                ID&nbsp;
                <span className="fa fa-caret-square-o-down"></span>
              </button>
              <ul className="dropdown-menu" aria-labelledby="dropdownEmpID">
                <li onClick={() => this.onSort("empID", -1)}>
                  <a
                    role="button"
                    className={
                      this.state.sortby === "empID" &&
                      this.state.sortvalue === -1
                        ? "sort_selected"
                        : ""
                    }
                  >
                    <span className="fa fa-angle-double-down">
                      {" "}
                      &nbsp; Lớn đến bé
                    </span>
                  </a>
                </li>
                <li onClick={() => this.onSort("empID", 1)}>
                  <a
                    role="button"
                    className={
                      this.state.sortby === "empID" &&
                      this.state.sortvalue === 1
                        ? "sort_selected"
                        : ""
                    }
                  >
                    <span className="fa fa-angle-double-up">
                      {" "}
                      &nbsp; Bé đến lớn
                    </span>
                  </a>
                </li>
              </ul>
            </div>
          </th>
          <th className="text_center">
            <div className="dropdown">
              <button
                type="button"
                className="btn dropdown-toggle"
                id="dropdownName"
                data-toggle="dropdown"
                aria-haspopup="true"
                aria-expanded="true"
              >
                Tên &nbsp;
                <span className="fa fa-caret-square-o-down"></span>
              </button>
              <ul className="dropdown-menu" aria-labelledby="dropdownName">
                <li onClick={() => this.onSort("empName", -1)}>
                  <a
                    role="button"
                    className={
                      this.state.sortby === "empName" &&
                      this.state.sortvalue === -1
                        ? "sort_selected"
                        : ""
                    }
                  >
                    <span className="fa fa-sort-alpha-down">
                      {" "}
                      &nbsp; A -&gt; Z
                    </span>
                  </a>
                </li>
                <li onClick={() => this.onSort("empName", 1)}>
                  <a
                    role="button"
                    className={
                      this.state.sortby === "empName" &&
                      this.state.sortvalue === 1
                        ? "sort_selected"
                        : ""
                    }
                  >
                    <span className="fa fa-sort-alpha-up">
                      {" "}
                      &nbsp; Z -&gt; A
                    </span>
                  </a>
                </li>
              </ul>
            </div>
          </th>
          <th className="text_center">
            <button className="btn text_center">Số điện thoại</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Giới tính</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Địa chỉ</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Email</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Lương/giờ</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Trạng thái</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Loại</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Vị trí nghiệp vụ</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Bằng lái xe</button>
          </th>
          <th className="text_center">
            <button className="btn text_center">Hành động</button>
          </th>
        </tr>
      </thead>
    );
  }
}

export default Sort;
