# rename from run-linux.csh to un-linux.sh for .sh bash color highlight

#for flownum in 
# for flownum in 5 10 20 50 100 200 
for flownum in 1 5 20 100 200 300 400 500
#2 8 32 128
do

	for bw in 150
#1 10 100 1000
	do
		#sidebw=`echo "$bw*4" | bc`
		sidebw=1500
		for onewaydelay in 64
#2 8 32 128
		do
			#buffer=`echo "$bw*$onewaydelay*25/1448" | bc`
			#if [ $buffer -lt 100 ]
			#then
			#	buffer=100
			#fi
			# BDP = Mbps * ms *2 = Kbps * s * 2 = Kb *2 = Kb * 2 /8bpB / 1448Bp pkt = 1000*2/8*1448=250/1448
			# We use 1/10 of BDP
			buffer=220
			
			# 减小 endtime 可以起到加快测试的效果
			for endtime in 120
			#for endtime in 900
#20 200
			do
				#for i in highspeed reno htcp cubic hybla westwood bic vegas scalable
#highspeed reno vegas bic htcp cubic westwood hybla scalable
#htcp westwood cubic highspeed reno vegas
				#for i in veno lp yeah illinois compound

				# for i in bic cubic highspeed htcp hybla reno scalable vegas westwood veno lp yeah illinois compound cong;
				for i in cubic;
				do
					dirname=$flownum-$bw-$onewaydelay-$endtime-$i
#					rm $dirname -r
					mkdir $dirname
					cd $dirname
					echo "Agent/TCP/Linux" > config
					echo $i >> config
					echo $flownum >> config
					echo $bw"Mb" >> config
					echo $onewaydelay"ms" >> config
					echo $buffer >> config
					echo $sidebw"Mb" >> config
					echo $endtime >> config

					sttime=`cat /proc/uptime | awk '{print $1}'`
					date > time_report
					pwd
					# ns ../../test-linux.tcl > txt
					# 打开调试信息
					ns ../../test-buffer.tcl
					
					edtime=`cat /proc/uptime | awk '{print $1}'`
					date >> time_report
					echo "$edtime - $sttime" | bc >> time_report
					
					# -${dirname}
					# 绘制队列占用图形
					xgraph.py -l queue0-size queue0
					xgraph.py -l util0 util0
					
					cd ..
				done
			done
		done
	done
done
