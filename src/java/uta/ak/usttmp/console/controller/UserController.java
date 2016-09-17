/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.controller;

import java.util.ArrayList;
import java.util.List;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
 
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import uta.ak.usttmp.console.model.User;
 
@Controller
public class UserController {
    /**
     * Static list of users to simulate Database
     */
//    private static List<User> userList = new ArrayList<User>();
    
    @Autowired
    private DataSource dataSource;
 
    //Initialize the list with some data for index screen
//    static {
//        userList.add(new User("Bill", "Gates"));
//        userList.add(new User("Steve", "Jobs"));
//        userList.add(new User("Larry", "Page"));
//        userList.add(new User("Sergey", "Brin"));
//        userList.add(new User("Larry", "Ellison"));
//    }
 
    /**
     * Saves the static list of users in model and renders it 
     * via freemarker template.
     * 
     * @param model 
     * @return The index view (FTL)
     */
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String index(@ModelAttribute("model") ModelMap model) {
 
        JdbcTemplate jt=new JdbcTemplate(dataSource);
        
 
        return "index";
    }
 
    /**
     * Add a new user into static user lists and display the 
     * same into FTL via redirect 
     * 
     * @param user
     * @return Redirect to /index page to display user list
     *
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    public String add(@ModelAttribute("user") User user) {
 
        if (null != user && null != user.getFirstname()
                && null != user.getLastname() && !user.getFirstname().isEmpty()
                && !user.getLastname().isEmpty()) {
 
            synchronized (userList) {
                userList.add(user);
            }
 
        }
 
        return "redirect:index.html";
    }*/

    /**
     * @return the dataSource
     */
    public DataSource getDataSource() {
        return dataSource;
    }

    /**
     * @param dataSource the dataSource to set
     */
    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
 
}
