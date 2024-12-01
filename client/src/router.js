import React from "react";
import ListEmployee from "./ListEmployee/ListEmployee";
import AddForm from "./ListEmployee/Components/AddForm";
import EmployeeSalaryReport from "./Salary/Salary";

const routes = [
  {
    path: "/list-employees",
    exact: true,
    main: () => <ListEmployee />,
  },
  {
    path: "/list-employees/add",
    exact: true,
    main: () => <AddForm />,
  },
  {
    path: "/list-employees/salary",
    exact: true,
    main: () => <EmployeeSalaryReport />,
  },
];

export default routes;
