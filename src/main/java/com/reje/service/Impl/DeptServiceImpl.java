package com.reje.service.Impl;

import com.reje.mapper.DeptMapper;
import com.reje.pojo.Dept;
import com.reje.service.DeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DeptServiceImpl implements DeptService {

    @Autowired
    DeptMapper deptMapper;

    @Override
    public List<Dept> DeptList() {
        List<Dept> deptList = deptMapper.selectByExample(null);
        return deptList;
    }
}
