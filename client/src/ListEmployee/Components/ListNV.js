/* eslint-disable react/style-prop-object */
/* eslint-disable jsx-a11y/anchor-is-valid */
import React, { Component } from "react";
import Sort from "./Sort";
import OneRowData from "./OneRowData";

class ListNV extends Component {
  constructor(props) {
    super(props);
    this.state = {
      employees: props.employees || [],
      filter: {
        empID: "",
        empName: "",
        empSex: "",
        empType: "",
        empStatus:"",
      },
      sort: {
        by: "empID",
        value: 1,
      },
    };
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    if (nextProps.employees !== prevState.employees) {
      return { employees: nextProps.employees };
    }
    return null;
  }

  onDelete = (_id) => {
    this.props.onDelete(_id);
  };

  onChange = (event) => {
    const { name, value } = event.target;
    this.setState({
      filter: {
        ...this.state.filter,
        [name]: value,
      },
    });
  };

  onSort = (sortBy, sortValue) => {
    this.setState({
      sort: {
        by: sortBy,
        value: sortValue,
      },
    });
  };

  render() {
    const { filter, sort } = this.state;
    let employees = [...this.props.employees];

    // Apply filters
    if (filter) {
      if (filter.empID) {
        employees = employees.filter((employee) =>
          employee.empID.startsWith(filter.empID)
        );
      }
      if (filter.empName) {
        employees = employees.filter((employee) =>
          employee.empName.toLowerCase().includes(filter.empName.toLowerCase())
        );
      }
      if (filter.empSex) {
        employees = employees.filter((employee) =>
          filter.empSex === "all" ? true : employee.empSex === filter.empSex
        );
      }
      if (filter.empType) {
        employees = employees.filter((employee) =>
          filter.empType === "all" ? true : employee.empType === filter.empType
        );
      }
      if (filter.empStatus) {
        employees = employees.filter((employee) =>
          filter.empStatus === "all" ? true : employee.empStatus === filter.empStatus
        );
      }
    }

    // Apply sorting
    if (sort) {
      employees.sort((a, b) => {
        const valueA = a[sort.by];
        const valueB = b[sort.by];
        if (valueA > valueB) return sort.value;
        if (valueA < valueB) return -sort.value;
        return 0;
      });
    }

    const employeeList = employees.map((employee, index) => (
      <OneRowData
        key={employee.id}
        index={index}
        employee={employee}
        onDelete={this.onDelete}
      />
    ));

    return (
      <div>
        <table className="table table-bordered table-hover">
          <Sort onSort={this.onSort} />

          <tbody>
            <tr>
              <td></td>
              <td>
                <input
                  type="text"
                  className="form-control"
                  name="empID"
                  value={filter.empID}
                  onChange={this.onChange}
                  placeholder="ID NV"
                />
              </td>
              <td>
                <input
                  type="text"
                  className="form-control"
                  name="empName"
                  value={filter.empName}
                  onChange={this.onChange}
                  placeholder="Họ và tên"
                />
              </td>
              <td></td>
              <td>
                <select
                  className="form-control"
                  name="empSex"
                  value={filter.empSex}
                  onChange={this.onChange}
                >
                  <option value="all"></option>
                  <option value="Nam">Nam</option>
                  <option value="Nữ">Nữ</option>
                </select>
              </td>
              <td>
              </td>
              <td></td>
              <td>
              </td>
              <td>
              <select
                className="form-control"
                name="empStatus"
                value={filter.empStatus}
                onChange={this.onChange}
              >
                <option value="all"></option>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
                <option value="On Leave">On Leave</option>
                <option value="Suspended">Suspended</option>
              </select>

              </td>
              <td>
                <select
                  className="form-control"
                  name="empType"
                  value={filter.empType}
                  onChange={this.onChange}
                >
                  <option value="all"></option>
                  <option value="Phục vụ">Phục vụ</option>
                  <option value="Giao hàng">Giao hàng</option>
                  <option value="Thu ngân">Thu ngân</option>
                  <option value="Quản lý">Quản lý</option>
                </select>
              </td>
              <td></td>
              <td></td>
            </tr>
            {employeeList}
          </tbody>
        </table>
      </div>
    );
  }
}

export default ListNV;
