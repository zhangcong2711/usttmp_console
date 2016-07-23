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

    topicEvolutionDiagram.size = function (_) {
        if (!arguments.length) return size;
        size = _;
        return topicEvolutionDiagram;
    };

    topicEvolutionDiagram.layout = function () {
        computeNodeLinks();
        computeNodeValues();
        computeNodeBreadths();
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

        scaleNodeBreadths((width - nodeWidth) / (x - 1));
    }

    function scaleNodeBreadths(kx) {
        nodes.forEach(function(node) {
            node.x *= kx;
        });
    }

    function computeNodeDepths() {
        // var nodesBySeq = d3.nest()
        //     .key(function(d) { return d.seq; })
        //     .sortKeys(d3.ascending)
        //     .entries(nodes);
        //     // .map(function(d) { return d.values; });

        var nodesBySeq=[];
        var groupByArr = {};

        for (var i = 0; i < nodes.length; ++i) {
            var obj = nodes[i];

            if (groupByArr[obj.seq] === undefined){
                groupByArr[obj.seq] = [obj];
            }else {
                groupByArr[obj.seq].push(obj);
            }
        }

        for (var gbattr in groupByArr)
        {
            nodesBySeq.push(groupByArr[gbattr]);
        }

        initializeNodeDepth();

        function initializeNodeDepth() {

            var tHeight=height-topicNum * nodePadding;

            nodesBySeq.forEach(function(tnodes) {

                tnodes.sort(ascendingTopicId);
                for(var i=0;i<tnodes.length;i++){

                    var tNode=tnodes[i];
                    if(i>0){
                        var preNode=tnodes[i-1];
                        tNode.y=nodePadding + preNode.y + preNode.barHeight;
                    }else{
                        tNode.y=nodePadding;
                    }
                    tNode.barHeight = tNode.normalizedHeat * tHeight / 100;
                    // tNode.barHeight = 50;
                    // tNode.dx=0;
                    // tNode.dy=tNode.barHeight/2-2;
                }
            });
        }

        function ascendingTopicId(a, b) {
            return a.topidId - b.topidId;
        }

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