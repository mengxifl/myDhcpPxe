rm -rf /node_exporter
mkdir /node_exporter
curl -s http://10.130.147.239/software/node_exporter/node_exporter -o /node_exporter/node_exporter
curl -s http://10.130.147.239/software/node_exporter/node_exporter.service -o /node_exporter/node_exporter.service
chmod 777 /node_exporter/node_exporter
chmod 777 /node_exporter/node_exporter.service
cp -rf /node_exporter/node_exporter.service /usr/lib/systemd/system/node_exporter.service
systemctl -q enable node_exporter.service
systemctl start node_exporter.service
systemctl status node_exporter.service