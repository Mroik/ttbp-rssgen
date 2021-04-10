#!/bin/sh
user=$(whoami)
cd ~
echo -n "Specify the blog location(~/public_html/blog/): "
read location
if [ -z $location ]
then
	location="/home/$user/public_html/blog/rss.xml"
else
	location="$location/rss.xml"
fi

{
	echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	echo "<rss version=\"2.0\">"
	echo "<channel>"
	echo "<title>~$user on TTBP</title>"
	echo "<link>http://tilde.town/~$user/blog/</link>"
	echo "<updated>$(date)</updated>"
	echo "<description>$user's blog on tilde.town</description>"
} > $location

for x in $(ls /home/$user/.ttbp/entries)
do
	{
		echo "<item>"
		echo "<title>$(echo $x | sed -E s/\.txt//g)</title>"
		echo "<pubDate>$(echo $x | awk '{printf substr($0,1,4) "-" substr($0,5,2) "-" substr($0,7,2)}')</pubDate>"
		echo "<link>http://tilde.town/~$user/blog/$(echo $x | sed -E s/\.txt/\.html/)</link>"
		echo "<description><![CDATA[$(cat /home/$user/.ttbp/entries/$x)]]></description>"
		echo "<author>$user@tilde.town</author>"
		echo "</item>"
	} >> $location
done

{
	echo "</channel>"
	echo "</rss>"
} >> $location

echo "Finished generating rss feed... you can now go to $(echo $location | sed -E "s/^.*public_html/http:\/\/tilde\.town\/~$user/")"
