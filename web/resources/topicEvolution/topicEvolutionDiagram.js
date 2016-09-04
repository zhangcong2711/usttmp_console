/**
 * Created by zhangcong on 16/7/20.
 */
d3.topicEvolutionDiagram = function() {
    var topicEvolutionDiagram = {},
        topicNum = 20,
        nodeWidth = 24,
        nodePadding = 8,
        size = [1, 1],
        nodes = [],
        links = [];
        labels=[];

    topicEvolutionDiagram.topicNum = function (_) {
        if (!arguments.length) return topicNum;
        topicNum = +_;
        return topicEvolutionDiagram;
    };

    topicEvolutionDiagram.nodeWidth = function (_) {
        if (!arguments.length) return nodeWidth;
        nodeWidth = +_;
        return topicEvolutionDiagram;
    };

    topicEvolutionDiagram.nodePadding = function (_) {
        if (!arguments.length) return nodePadding;
        nodePadding = +_;
        return topicEvolutionDiagram;
    };

    topicEvolutionDiagram.nodes = function (_) {
        if (!arguments.length) return nodes;
        nodes = _;
        return topicEvolutionDiagram;
    };

    topicEvolutionDiagram.links = function (_) {
        if (!arguments.length) return links;
        links = _;
        return topicEvolutionDiagram;
    };

    topicEvolutionDiagram.labels = function (_) {
        if (!arguments.length) return labels;
        labels = _;
        return topicEvolutionDiagram;
    };

    topicEvolutionDiagram.size = function (_) {
        if (!arguments.length) return size;
        size = _;
        return topicEvolutionDiagram;
    };

    topicEvolutionDiagram.layout = function () {
        computeNodeLinks();
        computeNodeValues();
        computeNodeBreadths();
        computeLabelBreadths();
        computeNodeDepths();
        computeLinkDepths();
        return topicEvolutionDiagram;
    };

    function computeNodeLinks() {
        nodes.forEach(function(node) {
            node.sourceLinks = [];
            node.targetLinks = [];
            links.forEach(function(link) {
                var source = link.source,
                    target = link.target;
                if (typeof source === "number" && node.topicId==source){
                    node.sourceLinks.push(link);
                }
                if (typeof target === "number" && node.topicId==target){
                    node.targetLinks.push(link);
                }
            });
        });

    }

    function computeNodeValues() {
        nodes.forEach(function(node) {
            node.value=node.normalizedHeat;
        });
    }

    topicEvolutionDiagram.link = function() {
        var curvature = .5;

        function link(d) {

            var dsource;
            var dtarget;
            topicEvolutionDiagram.nodes().forEach(function(node) {
                if(node.topicId == d.source){
                    dsource=node;
                }
                if(node.topicId == d.target){
                    dtarget=node;
                }
            });

            var x0 = dsource.x + topicEvolutionDiagram.nodeWidth(),
                y0 = dsource.y + dsource.barHeight/2,
                x3 = dtarget.x,
                y3 = dtarget.y + dtarget.barHeight/2,
                x1 = x0 + (x3-x0)/3,
                x2 = x3 - (x3-x0)/3;

            return "M" + x0 + "," + y0
                + "C" + x1 + "," + y0
                + " " + x2 + "," + y3
                + " " + x3 + "," + y3;
        }

        link.curvature = function(_) {
            if (!arguments.length) return curvature;
            curvature = +_;
            return link;
        };

        return link;
    };

    function computeNodeBreadths() {
        var x=0;

        nodes.forEach(function(node) {
            node.x = node.seq-1;
            if(node.seq>x){
                x=node.seq;
            }
        });
        
        scaleNodeBreadths((0!=(x-1)) ? 
                          ((chartWidth - nodeWidth * x - 300) / (x - 1)) :
                          0 );
    }

    function scaleNodeBreadths(kx) {
        nodes.forEach(function(node) {
            if(0!=kx){
                node.x *= kx;
            }else{
                node.x = 1;
            }
            
        });
    }

    function computeLabelBreadths() {
        var x=0;

        labels.forEach(function(node) {
            node.x = node.seq-1;
            if(node.seq>x){
                x=node.seq;
            }
        });

        scaleLabelBreadthsAndDepths((0!=(x-1)) ?
            ((chartWidth - nodeWidth * x - 300) / (x - 1)) :
            0 );
    }

    function scaleLabelBreadthsAndDepths(kx) {
        labels.forEach(function(node) {
            if(0!=kx){
                node.x *= kx;
            }else{
                node.x = 1;
            }

            node.y=nodePadding + 5;

        });
    }

    function hasPostNodes(node){
        if(null!=node.sourceLinks && node.sourceLinks.length>0){
            return true;
        }else{
            return false;
        }
    }

    function getPostNodes(node, nextNodes){

        var nArr=[];
        for(var i=0;i<node.sourceLinks.length;i++){
            sLink=node.sourceLinks[i];
            for(var j=0;j<nextNodes.length;j++){
                nNode=nextNodes[j];
                if(nNode.topicId == sLink.target){
                    nArr.push(nNode);
                }
            }
        }

        return nArr;
    }


    function hasPriorNodes(node){
        if(null!=node.targetLinks && node.targetLinks.length>0){
            return true;
        }else{
            return false;
        }
    }

    /*
    function getPriorNodes(node, prevNodes){
        var pArr=[];
        for(var tLink in  node.targetLinks){
            for(var pNode in prevNodes){
                if(pNode.topicId == tLink.source){
                    pArr.push(pNode);
                }
            }
        }
        return pArr;
    }*/

    function keySize(obj) {
        var size = 0, key;
        for (key in obj) {
            if (obj.hasOwnProperty(key)) size++;
        }
        return size;
    };

    function resortTopicOrderInEveryGroup(groupByArr){

        var newGroupByArr=new Object();
        newGroupByArr[1]=groupByArr[1];

        var gbaLength=keySize(groupByArr);
        for (var i = 2; i <=gbaLength; i++) {

            var newNextTopics=resortNextTopicGroup(
                                newGroupByArr[i-1],
                                groupByArr[i]);
            newGroupByArr[i]=newNextTopics;
        }

        return newGroupByArr;
    }

    function resortNextTopicGroup(priorTopicArr, postTopicArr){

        var alreadyResortedNodes=[];

        for(var i=0;i<priorTopicArr.length;i++){

            var tp=priorTopicArr[i];
            if(hasPostNodes(tp)){

                var postNodes=getPostNodes(tp, postTopicArr);

                for(var j=0;j<postNodes.length;j++){
                    var pNode = postNodes[j];
                    if(alreadyResortedNodes.indexOf(pNode)>=0){

                    }else{
                        var pnIdx=postTopicArr.indexOf(pNode);
                        var fhnpIdx=searchFirstHasNoPriorBeforeTheIndex(pnIdx,postTopicArr);
                        if(-1!=fhnpIdx){
                            swapArrayElements(postTopicArr, pnIdx, fhnpIdx);
                        }
                        alreadyResortedNodes.push(pNode);
                    }

                }
            }
        }

        return postTopicArr;
    }

    function swapArrayElements(arr, indexA, indexB) {
        var temp = arr[indexA];
        arr[indexA] = arr[indexB];
        arr[indexB] = temp;
    };

    function searchFirstHasNoPriorBeforeTheIndex(bIdx, postTopicArr){

        var idx=-1;
        for(var i=0;i<bIdx;i++){
            if(!hasPriorNodes(postTopicArr[i])){
                idx=i;
                break;
            }
        }

        return idx;
    }

    function shuffleArray(a) {
        var j, x, i;
        for (i = a.length; i; i--) {
            j = Math.floor(Math.random() * i);
            x = a[i - 1];
            a[i - 1] = a[j];
            a[j] = x;
        }
    }

    function computeNodeDepths() {

        var nodesBySeq=[];
        var groupByArr = {};

        shuffleArray(nodes);

        for (var i = 0; i < nodes.length; ++i) {
            var obj = nodes[i];

            if (groupByArr[obj.seq] === undefined){
                groupByArr[obj.seq] = [obj];
            }else {
                groupByArr[obj.seq].push(obj);
            }
        }

        //Make diagram having less crossing links. Easy to view.
        var newOrganizedGroupArr=resortTopicOrderInEveryGroup(groupByArr);

        for (var gbattr in newOrganizedGroupArr)
        {
            nodesBySeq.push(newOrganizedGroupArr[gbattr]);
        }

        initializeNodeDepth();

        function initializeNodeDepth() {


            var tHeight=(topicEvolutionDiagram.size())[1]-topicNum * nodePadding;

            nodesBySeq.forEach(function(tnodes) {

                //tnodes.sort(ascendingTopicId);
                for(var i=0;i<tnodes.length;i++){

                    var tNode=tnodes[i];
                    if(i>0){
                        var preNode=tnodes[i-1];
                        tNode.y=nodePadding + preNode.y + preNode.barHeight;
                    }else{
                        tNode.y=nodePadding + 50;
                    }
                    tNode.barHeight = tNode.normalizedHeat * tHeight / 100;
                    // tNode.barHeight = 50;
                    // tNode.dx=0;
                    // tNode.dy=tNode.barHeight/2-2;
                }
            });
        }

        // function ascendingTopicId(a, b) {
        //     return a.topidId - b.topidId;
        // }

    }

    function computeLinkDepths() {
        nodes.forEach(function(node) {
            node.sourceLinks.sort(ascendingTargetDepth);
            node.targetLinks.sort(ascendingSourceDepth);
        });
        nodes.forEach(function(node) {
            var sy = 0, ty = 0;
            node.sourceLinks.forEach(function(link) {
                link.sy = sy;
                sy += link.dy;
            });
            node.targetLinks.forEach(function(link) {
                link.ty = ty;
                ty += link.dy;
            });
        });

        function ascendingSourceDepth(a, b) {
            return a.source.y - b.source.y;
        }

        function ascendingTargetDepth(a, b) {
            return a.target.y - b.target.y;
        }
    }

    topicEvolutionDiagram.relayout = function() {
        // computeNodeDepths();
        computeLinkDepths();
        return topicEvolutionDiagram;
    };

    return topicEvolutionDiagram;
}