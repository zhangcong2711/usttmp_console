{
"draw": 1,
"recordsTotal": ${count},
"recordsFiltered": ${count},
"data": [

<#list mtlList as mtl>
    {
    "id": "${mtl.id}",
    "info": "${mtl.info}",
    "occurrenceTime": "${mtl.occurrenceTime?string("yyyy-MM-dd HH:mm:ss")}",
    "type":<#switch mtl.type>
                        <#case 1>
                          "Info"
                          <#break>
                        <#case 2>
                          "Exception"
                          <#break>
                        <#default>
                          "Type Err"
                      </#switch>,
    "miningTaskId": "${mtl.miningTaskId}"
    }
    <#sep>, </#sep>
</#list>
]
}