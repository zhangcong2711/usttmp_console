{
  "draw": 1,
  "recordsTotal": ${count},
  "recordsFiltered": ${count},
  "data": [
  
    <#list mtList as mt>
        {
            "taskId": "${mt.id}",
            "taskName": "${mt.name}",
            "tag": "${mt.tag}",
            "startTime": "${mt.startTime ?datetime}",
            "endTime": "${mt.endTime ?datetime}",
            "miningInterval": "${mt.miningInterval}",
            "status":<#switch mt.status>
                        <#case 1>
                          "Running"
                          <#break>
                        <#case 2>
                          "Completed"
                          <#break>
                        <#case 3>
                          "Stoped"
                          <#break>
                        <#case 4>
                          "Not started"
                          <#break>
                        <#default>
                          "Status Err"
                      </#switch>,
            "progress": "${mt.qrtzJobExecCount/mt.qrtzJobTotalCount*100 ?int}%"
        }
        <#sep>, </#sep>
    </#list>
  ]
}