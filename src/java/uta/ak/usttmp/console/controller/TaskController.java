/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.controller;

import java.io.StringReader;
import java.io.StringWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import uta.ak.usttmp.common.model.MiningTask;
import uta.ak.usttmp.common.systemconst.UsttmpConst;
import uta.ak.usttmp.common.systeminterface.UsttmpInterfaceManager;
import uta.ak.usttmp.common.systeminterface.model.CallResult;
import uta.ak.usttmp.common.systeminterface.model.Message;
import uta.ak.usttmp.common.util.UsttmpXmlUtil;
 
@Controller
public class TaskController {
    
    @Autowired
    private UsttmpInterfaceManager consoleService;
    
    @RequestMapping("/newTask")
    public ModelAndView newTask() {
 
        ModelAndView mav=new ModelAndView("newTask");
//        mav.addObject("message", message);
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
                                 String tag) throws Exception {
 
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
    
}
