/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.controller;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PropertiesLoaderUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import uta.ak.usttmp.common.model.MiningTask;
import uta.ak.usttmp.common.model.MiningTaskLog;
import uta.ak.usttmp.common.service.TopicMiningService;
import uta.ak.usttmp.common.systemconst.UsttmpConst;
import uta.ak.usttmp.common.systeminterface.UsttmpInterfaceManager;
import uta.ak.usttmp.common.systeminterface.model.CallResult;
import uta.ak.usttmp.common.systeminterface.model.Message;
import uta.ak.usttmp.common.util.UsttmpXmlUtil;
 
@Controller
public class TaskController {
    
    @Autowired
    private UsttmpInterfaceManager consoleService;
    
    @Autowired
    private TopicMiningService topicMiningService;
    
    @RequestMapping("/newTask")
    public ModelAndView newTask() {
        
        ModelAndView mav=new ModelAndView("newTask");
        
        try {
            Resource preprocessRes = new ClassPathResource("preprocess.properties");
            Resource miningRes = new ClassPathResource("mining.properties");
            Resource trackingRes = new ClassPathResource("tracking.properties");
            Properties preprocessProps = PropertiesLoaderUtils.loadProperties(preprocessRes);
            Properties miningProps = PropertiesLoaderUtils.loadProperties(miningRes);
            Properties trackingProps = PropertiesLoaderUtils.loadProperties(trackingRes);
            
            List<Map> preprocessCPList = new ArrayList<>();
            for(String key : preprocessProps.stringPropertyNames()) {
                
                String value = preprocessProps.getProperty(key);
                Map<String,String> hm=new HashMap();
                hm.put("cpName", key);
                hm.put("cpValue", value);
                preprocessCPList.add(hm);
            }
            
            List<Map> miningCPList = new ArrayList<>();
            for(String key : miningProps.stringPropertyNames()) {
                
                String value = miningProps.getProperty(key);
                Map<String,String> hm=new HashMap();
                hm.put("cpName", key);
                hm.put("cpValue", value);
                miningCPList.add(hm);
            }
            
            List<Map> trackingCPList = new ArrayList<>();
            for(String key : trackingProps.stringPropertyNames()) {
                
                String value = trackingProps.getProperty(key);
                Map<String,String> hm=new HashMap();
                hm.put("cpName", key);
                hm.put("cpValue", value);
                trackingCPList.add(hm);
            }
            
            mav.addObject("preprocessCp", preprocessCPList);
            mav.addObject("miningCp", miningCPList);
            mav.addObject("trackingCp", trackingCPList);
            
            
            
        } catch (IOException ex) {
            Logger.getLogger(TaskController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        return mav;
    }
    
    @RequestMapping(value = "/createNewTask", method = RequestMethod.POST)
    public ModelAndView createnNewTask(String taskname,
                                 String starttime,
                                 String endtime,
                                 int mininginterval,
                                 int topicnum,
                                 int keywordnum,
                                 double alpha,
                                 double beta,
                                 String tag,
                                 String preprocessCp,
                                 String miningCp,
                                 String trackingCp) throws Exception {
 
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                
        MiningTask mt=new MiningTask();
        mt.setName(taskname);
        mt.setStartTime(sdf.parse(starttime));
        mt.setEndTime(sdf.parse(endtime));
        mt.setMiningInterval(mininginterval);
        mt.setAlpha(alpha);
        mt.setBeta(beta);
        mt.setTopicNum(topicnum);
        mt.setKeywordNum(keywordnum);
        mt.setTag(tag);
        mt.setPreprocessComponent(preprocessCp);
        mt.setMiningComponent(miningCp);
        mt.setTrackingComponent(trackingCp);
        
        Message responseMsg=consoleService.call(UsttmpConst.SUBSYSTEM_NAME_DMCORE, 
                            UsttmpInterfaceManager.INVOKE_TYPE_SYN,
                            "AddMiningTask",
                            UsttmpXmlUtil.objectToXmlStr(mt, mt.getClass(), true));
        
        CallResult cr = (CallResult)(UsttmpXmlUtil.xmlStrToObject(responseMsg.getMethodBody(), 
                                                                  CallResult.class));
        
        String text=null;
        if(CallResult.RESULT_SUCCESS.equals(cr.getResultStatus())){
            text=cr.getInfo();
        }else{
            text=cr.getError();
        }
        
        ModelAndView mav=new ModelAndView("backto");
        mav.addObject("text", text);
        mav.addObject("redirectUrl", "index");
        mav.addObject("redirectName", "Index page");
        return mav;
    }

    @RequestMapping("/deleteTask")
    public ModelAndView deleteTask(String miningTaskId) throws Exception  {
 
        Message responseMsg=consoleService.call(UsttmpConst.SUBSYSTEM_NAME_DMCORE, 
                            UsttmpInterfaceManager.INVOKE_TYPE_SYN,
                            "DeleteMiningTask",
                            miningTaskId);
        
        CallResult cr = (CallResult)(UsttmpXmlUtil.xmlStrToObject(responseMsg.getMethodBody(), 
                                                                  CallResult.class));
        
        String text=null;
        if(CallResult.RESULT_SUCCESS.equals(cr.getResultStatus())){
            text=cr.getInfo();
        }else{
            text=cr.getError();
        }
 
        ModelAndView mav=new ModelAndView("backto");
        mav.addObject("text", text);
        mav.addObject("redirectUrl", "index");
        mav.addObject("redirectName", "Index page");
        return mav;
    }
    
    @RequestMapping("/stopTask")
    public ModelAndView stopTask(String miningTaskId) throws Exception {
        
        Message responseMsg=consoleService.call(UsttmpConst.SUBSYSTEM_NAME_DMCORE, 
                            UsttmpInterfaceManager.INVOKE_TYPE_SYN,
                            "StopMiningTask",
                            miningTaskId);
        
        CallResult cr = (CallResult)(UsttmpXmlUtil.xmlStrToObject(responseMsg.getMethodBody(), 
                                                                  CallResult.class));
        
        String text=null;
        if(CallResult.RESULT_SUCCESS.equals(cr.getResultStatus())){
            text=cr.getInfo();
        }else{
            text=cr.getError();
        }
 
        ModelAndView mav=new ModelAndView("backto");
        mav.addObject("text", text);
        mav.addObject("redirectUrl", "index");
        mav.addObject("redirectName", "Index page");
        return mav;
    }
    
    @RequestMapping("/taskException")
    public ModelAndView taskException(String miningTaskId) throws Exception {
        
        MiningTask mt=topicMiningService
                            .getMiningTask(Long.parseLong(miningTaskId));
        
        ModelAndView mav=new ModelAndView("exceptionView");
        mav.addObject("miningTaskName", mt.getName());
        mav.addObject("miningTask", mt);
        return mav;
    }
    
    
    
    
    
    
    /**
     * @return the consoleService
     */
    public UsttmpInterfaceManager getConsoleService() {
        return consoleService;
    }

    /**
     * @param consoleService the consoleService to set
     */
    public void setConsoleService(UsttmpInterfaceManager consoleService) {
        this.consoleService = consoleService;
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
