package MapperTest;

import com.reje.mapper.DeptMapper;
import com.reje.mapper.EmpMapper;
import com.reje.pojo.Dept;
import com.reje.pojo.Emp;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Test
    public void test(){
        ApplicationContext ctx =new ClassPathXmlApplicationContext("applicationContext.xml");
        DeptMapper deptMapper = ctx.getBean(DeptMapper.class);
        //org.apache.ibatis.binding.MapperProxy@3ddc6915

//      deptMapper.insertSelective(new Dept(null,"设计部"));


//        EmpMapper empMapper = ctx.getBean(EmpMapper.class);
//        empMapper.insertSelective(new Emp(null,"slb","男","1132122117@qq.com",2));

        SqlSession sqlSession = (SqlSession) ctx.getBean("sqlSessionTemplate");
        EmpMapper empMapper = sqlSession.getMapper(EmpMapper.class);
        for (int i = 0; i <100 ; i++) {
            String uid = UUID.randomUUID().toString().substring(0,5)+i;
            if(i%2==0){
                empMapper.insertSelective(new Emp(null,"ano"+uid,"女","ano"+uid+"@reHeLu.com",2));
            }
            else {
                empMapper.insertSelective(new Emp(null,"ano"+uid,"男","ano"+uid+"@reHeLu.com",3));
            }
        }
        System.out.println("批量完成");
    }
}
