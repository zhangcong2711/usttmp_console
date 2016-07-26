{"nodes":[

    <#list topicList as tp>
        {"topicId":${tp.id?c} ,
         "name":"${tp.showName}", 
         "normalizedHeat":${tp.normalizedHeat},
         "seq":${tp.seq?c}, 
         "normalizedWordProbabilitys" : "${tp.rawContent}"
        }
        <#sep>, </#sep>
    </#list>
],
"links":[
    <#list relaList as rela>
    {"source":${rela.preTopic.id?c},
     "target":${rela.nextTopic.id?c}, 
     "rankAgainstPreTopicInNextGroup":${rela.rankAgainstPreTopicInNextGroup?c}, 
     "rankAgainstNextTopicInPreGroup":${rela.rankAgainstNextTopicInPreGroup?c}
    } <#sep>, </#sep>
    </#list>

]}