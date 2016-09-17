/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uta.ak.usttmp.console.model.vo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import uta.ak.usttmp.common.model.Topic;
import uta.ak.usttmp.common.model.WordProbability;

/**
 *
 * @author zhangcong
 */
public class TopicVo extends Topic {
    
    private int normalizedHeat;
    private List<WordProbabilityVo> normalizedWordProbabilityMaps;
    private String showName;
    private String rawContent;

    public TopicVo(Topic tp) {
        
        this.setId(tp.getId());
        this.setName(tp.getName());
        this.setRemark(tp.getRemark());
        this.setWordProbabilityMaps(tp.getWordProbabilityMaps());
        this.setMiningTaskId(tp.getMiningTaskId());
        this.setSeq(tp.getSeq());
        
        double totalWeight = 0;
        for (WordProbability wp : this.getWordProbabilityMaps()) {
            totalWeight += wp.getProbability();
        }
        
        normalizedWordProbabilityMaps=new ArrayList<>();
        for (WordProbability wp : this.getWordProbabilityMaps()) {
            WordProbabilityVo wpv = new WordProbabilityVo(wp);
            wpv.setNormalizedProbability((int)((wpv.getProbability()/totalWeight)*100));
            normalizedWordProbabilityMaps.add(wpv);
        }
        
        
        
        Collections.sort(normalizedWordProbabilityMaps, 
                        new Comparator<WordProbabilityVo>() {
                            @Override
                            public int compare(WordProbabilityVo wpv1, WordProbabilityVo wpv2) {
                                return wpv1.getNormalizedProbability() > wpv2.getNormalizedProbability()
                                       ? -1 : 
                                       ((wpv1.getNormalizedProbability() < wpv2.getNormalizedProbability()) 
                                       ? 1 : 0);
                            }
                        });
        
        if(normalizedWordProbabilityMaps.size()<=2){
            showName=this.getId() + ": " +
                 normalizedWordProbabilityMaps.get(0).getWord() + " ...";
        }else{
            showName=this.getId() + ": " +
                 normalizedWordProbabilityMaps.get(0).getWord() + ", " +
                 normalizedWordProbabilityMaps.get(1).getWord() + ", " +
                 normalizedWordProbabilityMaps.get(2).getWord() + "...";
        }
        
        
        long seed = System.nanoTime();
        Collections.shuffle(normalizedWordProbabilityMaps, new Random(seed));
        
    }

    /**
     * @return the normalizedHeat
     */
    public int getNormalizedHeat() {
        return normalizedHeat;
    }

    /**
     * @param normalizedHeat the normalizedHeat to set
     */
    public void setNormalizedHeat(int normalizedHeat) {
        this.normalizedHeat = normalizedHeat;
    }

    /**
     * @return the normalizedWordProbabilityMaps
     */
    public List<WordProbabilityVo> getNormalizedWordProbabilityMaps() {
        return normalizedWordProbabilityMaps;
    }

    /**
     * @return the showName
     */
    public String getShowName() {
        return showName;
    }

    /**
     * @return the rawContent
     */
    public String getRawContent() {
        return this.toString();
    }

    @Override
    public String toString() {
        StringBuffer sb=new StringBuffer();
        Iterator<WordProbabilityVo> i=this.normalizedWordProbabilityMaps.iterator();
        for(;i.hasNext();){
            WordProbabilityVo wp=i.next();
            sb.append(wp.getWord()).append(":").append(wp.getNormalizedProbability()).append(",");
        }
        sb.deleteCharAt(sb.length()-1);
        return sb.toString();
    }
    
    
}
