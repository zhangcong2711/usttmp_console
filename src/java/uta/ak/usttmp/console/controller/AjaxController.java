/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import java.util.Set;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import uta.ak.usttmp.common.dao.UsttmpDaoSupport;
import uta.ak.usttmp.common.dao.mapper.EvolutionRelaRowMapper;
import uta.ak.usttmp.common.dao.mapper.MiningTaskRowMapper;
import uta.ak.usttmp.common.dao.mapper.TopicRowMapper;
import uta.ak.usttmp.common.model.EvolutionRelationship;
import uta.ak.usttmp.common.model.MiningTask;
import uta.ak.usttmp.common.model.MiningTaskLog;
import uta.ak.usttmp.common.model.Topic;
import uta.ak.usttmp.common.service.TopicMiningService;
import uta.ak.usttmp.console.model.vo.TopicVo;

/**
 *
 * @author zhangcong
 */
@Controller
@RequestMapping("ajax")
public class AjaxController{
    
    @Autowired
    private JdbcTemplate usttmpJdbcTemlate;
    
    @Autowired
    private TopicMiningService topicMiningService;
    
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
    
    @RequestMapping(value = "/loadTaskLogs")
    public ModelAndView loadTaskLogs(String miningTaskId) {
 
        MiningTask mt=topicMiningService
                            .getMiningTask(Long.parseLong(miningTaskId));
        List<MiningTaskLog> mtlList=topicMiningService
                                        .getMiningTaskLogs(Long.parseLong(miningTaskId));
        
        
        int count=(null!=mtlList)?mtlList.size():0;
        
        ModelAndView mav=new ModelAndView("/ajax/loadTaskLogs.ajax");
        mav.addObject("count", count);
        mav.addObject("miningTask", mt);
        mav.addObject("mtlList", mtlList);
        return mav;
    }
    
    
    @RequestMapping(value = "/getTopicDataByTaskId")
    public ModelAndView getTopicDataByTaskId(String taskId) {
        
        String tsql="select * from c_miningtask where mme_eid=?";
        MiningTask mt=(MiningTask) usttmpJdbcTemlate
                                    .queryForObject(tsql, 
                                                    new MiningTaskRowMapper(), 
                                                    taskId);
 
        String sql="select * from c_topic where miningtask_id=?";
        List<Topic> topicList=usttmpJdbcTemlate.query(sql, new TopicRowMapper(), taskId);
        
        String relasql="select * from c_topicevolutionrela where miningtask_id=?";
        List<EvolutionRelationship> relaList=usttmpJdbcTemlate.query(relasql,
                                                                     new EvolutionRelaRowMapper(usttmpJdbcTemlate),
                                                                     taskId);
        
        //group topic
        Map<Integer, List<Topic>> hashMap = new HashMap<Integer, List<Topic>>();
        for(Iterator<Topic> i=topicList.iterator();
            i.hasNext();){
            
            Topic tp=i.next();
            if (!hashMap.containsKey(tp.getSeq())) {
                List<Topic> list = new ArrayList<Topic>();
                list.add(tp);

                hashMap.put(tp.getSeq(), list);
            } else {
                hashMap.get(tp.getSeq()).add(tp);
            }
        }
        
        List<TopicVo> tpvoList=new ArrayList<>();
        
        Set es = hashMap.entrySet();
        for(Iterator i=es.iterator();i.hasNext();){
            Entry key=(Entry) i.next();
            List<Topic> subtl = (List<Topic>) key.getValue();
            
            double totalHeat=0;
            for (Topic tp : subtl) {
                totalHeat+=tp.getHeat();
            }
            
            for (Topic tp : subtl) {
                TopicVo tvo=new TopicVo(tp);
                tvo.setNormalizedHeat((int)((tvo.getHeat()/totalHeat)*100));
                tpvoList.add(tvo);
            }
        }
        
        int maxSeq=0;
        for(TopicVo tvo : tpvoList){
            if(tvo.getSeq()>maxSeq){
                maxSeq=tvo.getSeq();
            }
        }
        
        Date startTime=mt.getStartTime();
        int intervalHours=mt.getMiningInterval();
        
        Calendar cal = Calendar.getInstance();
        
            
        List<Map> labeList=new ArrayList<>();
        for(int i=1;i<=maxSeq;i++){
            
            cal.setTime(startTime);
            cal.add(Calendar.HOUR_OF_DAY,
                    intervalHours * i);
            
            HashMap<String,String> hm=new HashMap<>();
            
            hm.put("seq", String.valueOf(i));
            hm.put("name",cal.getTime().toString());
            
            labeList.add(hm);
        }
        
        ModelAndView mav=new ModelAndView("/ajax/getTopicDataByTaskId.ajax");
        mav.addObject("topicCount", tpvoList.size());
        mav.addObject("topicList", tpvoList);
        mav.addObject("relaList", relaList);
        mav.addObject("labelList", labeList);
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

    /**
     * @return the topicMiningService
     */
    public TopicMiningService getTopicMiningService() {
        return topicMiningService;
    }

    /**
     * @param topicMiningService the topicMiningService to set
     */
    public void setTopicMiningService(TopicMiningService topicMiningService) {
        this.topicMiningService = topicMiningService;
    }
}
