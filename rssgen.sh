user=$(whoami)
cd ~
read -p "Specify the blog location(~/public_html/blog/): " location
if [ -z $location ]
then
	location="/home/$user/public_html/blog/rss.xml"
else
	location="$location/rss.xml"
fi

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $location
echo "<rss version=\"2.0\">" >> $location
echo "<channel>" >> $location
echo "<title>~$user on TTBP</title>" >> $location
echo "<link>http://tilde.town/~$user/blog/</link>" >> $location
echo "<updated>$(date)</updated>" >> $location
echo "<description>$user's blog on tilde.town</description>" >> $location

for x in $(ls /home/$user/.ttbp/entries)
do
	echo "<item>" >> $location
	echo "<title>$(echo $x | sed -E s/\.txt//g)</title>">> $location
	echo "<pubDate>$(echo $x | awk '{printf substr($0,1,4) "-" substr($0,5,2) "-" substr($0,7,2)}')</pubDate>" >> $location
	echo "<link>http://tilde.town/~$user/blog/$(echo $x | sed -E s/\.txt/\.html/)</link>" >> $location
	echo "<description><![CDATA[$(cat /home/$user/.ttbp/entries/$x)]]></description>" >> $location
	echo "<author>$user@tilde.town</author>" >> $location
	echo "</item>" >> $location
done

echo "</channel>" >> $location
echo "</rss>" >> $location

echo "Finished generating rss feed... you can now go to $(echo $location | sed -E "s/^.*public_html/http:\/\/tilde\.town\/~$user/")"
