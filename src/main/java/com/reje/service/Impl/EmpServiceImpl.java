package com.reje.service.Impl;

import com.reje.mapper.EmpMapper;
import com.reje.pojo.Emp;
import com.reje.pojo.EmpExample;
import com.reje.service.EmpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmpServiceImpl implements EmpService {

    @Autowired
    EmpMapper empMapper;

    @Override
    public List<Emp> EmpList() {
        //这个查询条件就是按照emp的id顺序返回给前端
        //没加这个条件的时候返回的时候 左外连接查询会根据主表向从表一个一个的查，导致从表的dept_id等于1的先查出来
        //所以就会导致插入的数据 显示的顺序 就研发部的在一起，开发部的在一起，起飞部的在一起
        //不会按照最新的插入的顺序
        EmpExample empExample = new EmpExample();
        empExample.setOrderByClause("emp_id");
        List<Emp> empList = empMapper.selectByExampleWithDept(empExample);
        return empList;
    }

    @Override
    public int insert(Emp emp) {
        int i = empMapper.insertSelective(emp);
        return i;
    }

    @Override
    public int selectByName(String name) {
        EmpExample empExample = new EmpExample();
        empExample.createCriteria().andEmpNameEqualTo(name);
        int i = empMapper.countByExample(empExample);
        return i;
    }

    @Override
    public Emp getEmp(Integer empId) {
        Emp emp = empMapper.selectByPrimaryKey(empId);
        return emp;
    }

    @Override
    public void updateEmp(Emp emp) {
        empMapper.updateByPrimaryKeySelective(emp);
    }

    @Override
    public void deleteEmp(Integer empId) {
        empMapper.deleteByPrimaryKey(empId);
    }

    @Override
    public void deleteBatch(List<Integer> list) {
        EmpExample empExample  = new EmpExample();
        empExample.createCriteria().andEmpIdIn(list);
        empMapper.deleteByExample(empExample);

    }
}
