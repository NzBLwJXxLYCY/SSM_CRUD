package com.reje.service;

import com.reje.pojo.Emp;

import java.util.List;

public interface EmpService {
    List<Emp> EmpList();


    int insert(Emp emp);

    int selectByName(String empName);

    Emp getEmp(Integer empId);

    void updateEmp(Emp emp);

    void deleteEmp(Integer empId);

    void deleteBatch(List<Integer> list);
}
