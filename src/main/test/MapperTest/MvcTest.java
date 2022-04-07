package MapperTest;

import com.github.pagehelper.PageInfo;
import com.reje.pojo.Emp;
import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.DefaultMockMvcBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:springMVC.xml"})
public class MvcTest {
    //springMVC的容器
    @Autowired
    WebApplicationContext ctx;
    MockMvc mockMvc;
    //每次初始化

    @Before
    public void  initMockMVC(){
        mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
    }
    @Test
    public void testPage() throws Exception {
        //模拟拿到返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emp").param("pn", "5"))
                .andReturn();

        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("当前的页码,"+pageInfo.getPageNum());
        System.out.println("总的页码,"+pageInfo.getPages());
        System.out.println("总的记录数，"+pageInfo.getTotal());
        int[] nums = pageInfo.getNavigatepageNums();
        for (int num : nums) {
            System.out.print(" "+num);
        }
        List list = pageInfo.getList();
        for (Object emp : list) {
            System.out.println(emp);
        }

    }
}
