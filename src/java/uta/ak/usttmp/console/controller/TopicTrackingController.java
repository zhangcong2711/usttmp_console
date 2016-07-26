/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import uta.ak.usttmp.common.dao.mapper.MiningTaskRowMapper;
import uta.ak.usttmp.common.model.MiningTask;

/**
 *
 * @author zhangcong
 */
@Controller
public class TopicTrackingController {
    
    @Autowired
    private JdbcTemplate usttmpJdbcTemplate;
    
    @RequestMapping("/trackingTopic")
    public ModelAndView trackingTopic(String taskId) {
        
        String sql="select * from c_miningtask where mme_eid=?";
        MiningTask task=(MiningTask) usttmpJdbcTemplate.queryForObject(sql, 
                                          new MiningTaskRowMapper(), 
                                          taskId);
        
 
        ModelAndView mav=new ModelAndView("trackingTopic");
        mav.addObject("task", task);
        mav.addObject("basicWidth", task.getQrtzJobExecCount()*500);
        mav.addObject("basicHeight", task.getTopicNum()*50);
        mav.addObject("topicNum", task.getTopicNum());
        return mav;
    }

    /**
     * @return the usttmpJdbcTemplate
     */
    public JdbcTemplate getUsttmpJdbcTemplate() {
        return usttmpJdbcTemplate;
    }

    /**
     * @param usttmpJdbcTemplate the usttmpJdbcTemplate to set
     */
    public void setUsttmpJdbcTemplate(JdbcTemplate usttmpJdbcTemplate) {
        this.usttmpJdbcTemplate = usttmpJdbcTemplate;
    }
    
}
