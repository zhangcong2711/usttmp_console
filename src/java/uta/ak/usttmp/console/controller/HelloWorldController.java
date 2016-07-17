/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
 
@Controller
public class HelloWorldController {
 
    @RequestMapping("/hello")
    public ModelAndView helloWorld() {
 
        String message = "Hello World, Spring 3.0!";
        
        ModelAndView mav=new ModelAndView("hello");
        mav.addObject("message", message);
        mav.addObject("", message);
        return mav;
    }
    
    @RequestMapping("/hello2/helloagain")
    public ModelAndView helloWorldAgain() {
 
        String message = "Hello World, Spring 3.0!";
        return new ModelAndView("/hello2/helloagain", "message", message);
    }
    
}
