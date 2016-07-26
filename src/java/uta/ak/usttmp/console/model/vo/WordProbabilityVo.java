/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.model.vo;

import uta.ak.usttmp.common.model.WordProbability;

/**
 *
 * @author zhangcong
 */
public class WordProbabilityVo extends WordProbability {
    
    private int normalizedProbability;

    public WordProbabilityVo(WordProbability wp) {
        
        this.setWord(wp.getWord());
        this.setProbability(wp.getProbability());
    }
    
    /**
     * @return the normalizedProbability
     */
    public int getNormalizedProbability() {
        return normalizedProbability;
    }

    /**
     * @param normalizedProbability the normalizedProbability to set
     */
    public void setNormalizedProbability(int normalizedProbability) {
        this.normalizedProbability = normalizedProbability;
    }
    
}
