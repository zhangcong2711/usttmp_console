/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import uta.ak.usttmp.console.model.Foo;


@Controller
@RequestMapping("rest")
public class RestCheckController {
    
    @RequestMapping(value = "/checkStatus", method = RequestMethod.GET, produces = MediaType.TEXT_PLAIN_VALUE)  
    @ResponseBody
    public String checkStatus() {  
        return "Yes,I am alive.";
    }  
    
    
    @RequestMapping(value = "/foo/{id}", method = RequestMethod.GET, produces = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<String> getFoo(@PathVariable("id") long id) {
        System.out.println("Fetching User with id " + id);
//        Foo foo=new Foo();
//        foo.setId(id);
//        foo.setName("DFGHH");
//        foo.setEmail("qwertyui@163.com");
        return new ResponseEntity<String>("I am a foo "+id, HttpStatus.OK);
    }
    
    
    

}
