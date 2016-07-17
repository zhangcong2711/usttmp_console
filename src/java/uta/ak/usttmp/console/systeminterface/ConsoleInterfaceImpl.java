/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.systeminterface;

import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.core.env.Environment;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import uta.ak.usttmp.common.systemconst.UsttmpConst;
import uta.ak.usttmp.common.systeminterface.UsttmpInterfaceManager;
import uta.ak.usttmp.common.systeminterface.model.Message;
import uta.ak.usttmp.common.util.UsttmpXmlUtil;

/**
 *
 * @author zhangcong
 */
public class ConsoleInterfaceImpl implements UsttmpInterfaceManager {
    
    private String consoleUrl;
    private String consolePort;
    private String dmcoreUrl;
    private String dmcorePort;
    private String textreceiverUrl;
    private String textreceiverPort;
    

    @Override
    public Message call(String targetName, 
                        String invokeType, 
                        String methodName, 
                        String methodBody) throws Exception{
        
        Message msg=new Message();
        msg.setSource(UsttmpConst.SUBSYSTEM_NAME_CONSOLE);
        msg.setTarget(targetName);
        
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dt=formatter.format(new Date());
        msg.setTimeStamp(dt);
        
        msg.setType(UsttmpInterfaceManager.TYPE_CALL);
        msg.setInvokeType(invokeType);
        msg.setMethodName(methodName);
        msg.setMethodBody(methodBody);
        
        String msgstr=UsttmpXmlUtil.objectToXmlStr(msg, 
                                                   msg.getClass(),
                                                   false);
        String restUrl="http://" +
                       this.dmcoreUrl + ":" + this.dmcorePort +
                       "/" + UsttmpConst.SUBSYSTEM_NAME_DMCORE +
                       "/rest/interfaceResponser/";
        
        RestTemplate restTemplate = new RestTemplate();
        String responseMsg = restTemplate.postForObject(restUrl, 
                                                    StringEscapeUtils.escapeXml10(msgstr), 
                                                    String.class);
        
        return (Message) UsttmpXmlUtil.xmlStrToObject(responseMsg, Message.class);
        
    }

    @Override
    public Message response(String msg) throws Exception {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    /**
     * @return the consoleUrl
     */
    public String getConsoleUrl() {
        return consoleUrl;
    }

    /**
     * @param consoleUrl the consoleUrl to set
     */
    public void setConsoleUrl(String consoleUrl) {
        this.consoleUrl = consoleUrl;
    }

    /**
     * @return the consolePort
     */
    public String getConsolePort() {
        return consolePort;
    }

    /**
     * @param consolePort the consolePort to set
     */
    public void setConsolePort(String consolePort) {
        this.consolePort = consolePort;
    }

    /**
     * @return the dmcoreUrl
     */
    public String getDmcoreUrl() {
        return dmcoreUrl;
    }

    /**
     * @param dmcoreUrl the dmcoreUrl to set
     */
    public void setDmcoreUrl(String dmcoreUrl) {
        this.dmcoreUrl = dmcoreUrl;
    }

    /**
     * @return the dmcorePort
     */
    public String getDmcorePort() {
        return dmcorePort;
    }

    /**
     * @param dmcorePort the dmcorePort to set
     */
    public void setDmcorePort(String dmcorePort) {
        this.dmcorePort = dmcorePort;
    }

    /**
     * @return the textreceiverUrl
     */
    public String getTextreceiverUrl() {
        return textreceiverUrl;
    }

    /**
     * @param textreceiverUrl the textreceiverUrl to set
     */
    public void setTextreceiverUrl(String textreceiverUrl) {
        this.textreceiverUrl = textreceiverUrl;
    }

    /**
     * @return the textreceiverPort
     */
    public String getTextreceiverPort() {
        return textreceiverPort;
    }

    /**
     * @param textreceiverPort the textreceiverPort to set
     */
    public void setTextreceiverPort(String textreceiverPort) {
        this.textreceiverPort = textreceiverPort;
    }

}
