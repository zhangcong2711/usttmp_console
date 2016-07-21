/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.controller;

import java.util.List;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import uta.ak.usttmp.common.dao.UsttmpDaoSupport;
import uta.ak.usttmp.common.dao.mapper.MiningTaskRowMapper;
import uta.ak.usttmp.common.dao.mapper.TopicRowMapper;
import uta.ak.usttmp.common.model.MiningTask;
import uta.ak.usttmp.common.model.Topic;

/**
 *
 * @author zhangcong
 */
@Controller
@RequestMapping("ajax")
public class AjaxController{
    
    @Autowired
    private JdbcTemplate usttmpJdbcTemlate;
    
    @RequestMapping(value = "/loadAllTasks")
    public ModelAndView loadAllTask() {
 
        String sql="select * from c_miningtask";
        List<MiningTask> mtList=usttmpJdbcTemlate.query(sql, new MiningTaskRowMapper());
        
        int count=(null!=mtList)?mtList.size():0;
        
        ModelAndView mav=new ModelAndView("/ajax/loadAllTasks.ajax");
        mav.addObject("count", count);
        mav.addObject("mtList", mtList);
        return mav;
    }
    
    @RequestMapping(value = "/getTopicDataByTaskId")
    public ModelAndView getTopicDataByTaskId(String taskId) {
 
        String sql="select * from c_topic where miningtask_id=?";
        List<Topic> topicList=usttmpJdbcTemlate.query(sql, new TopicRowMapper(), taskId);
        
        
        ModelAndView mav=new ModelAndView("/ajax/getTopicDataByTaskId.ajax");
//        mav.addObject("count", count);
//        mav.addObject("mtList", mtList);
        return mav;
    }

    /**
     * @return the usttmpJdbcTemlate
     */
    public JdbcTemplate getUsttmpJdbcTemlate() {
        return usttmpJdbcTemlate;
    }

    /**
     * @param usttmpJdbcTemlate the usttmpJdbcTemlate to set
     */
    public void setUsttmpJdbcTemlate(JdbcTemplate usttmpJdbcTemlate) {
        this.usttmpJdbcTemlate = usttmpJdbcTemlate;
    }
}
