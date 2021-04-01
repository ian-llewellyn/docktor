FROM busybox

COPY ashrc /root/.ashrc

ENV ENV=/root/.ashrc
