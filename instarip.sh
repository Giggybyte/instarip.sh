# !/bin/bash
# instarip.sh
# by giggybyte
# Rips the content of a post from Instagram, whether it's an image or a video

# If the parameters provided aren't just a URL, show the usage
if [ $# -ne 1 ]; then
	echo ""
	echo "instarip.sh"
	echo "Usage: "
	echo "./instarip.sh <instagram media url>"
	echo ""
# Otherwise we can proceed to let 'er rip
else
	# Downloads the page and searches for the tag that describes
	# whether the content is an image or a video
	htmlResult=$(wget -qO insta.html $1 && grep "medium" insta.html)
	# Strips the HTML garbage. This might be the worst way of doing it but it
	# works so sue me.
	contentType=${htmlResult:33:-4}
	echo ""
	echo "Content type: "$contentType
	if [ $contentType = "video" ]; then
		# Search for the tag that has the video URL.
		contentHTML=$(grep '"og:video"' insta.html)
		# Strip away the HTML garbage.
		contentURL=${contentHTML:39:-4}
		# Print the URL to the user.
		echo " Content URL: "$contentURL
		# And finally use wget to download our precious video.
		wget $contentURL
		# Clean up our garbage. This file was used in the original http request.
		rm insta.html
	elif [ $contentType = "image" ]; then
		# Go through the same procedures, just searching for image instead of
		# video.
		contentHTML=$(grep '"og:image"' insta.html)
		contentURL=${contentHTML:39:-4}
		echo " Content URL: "$contentURL
		wget $contentURL
		rm insta.html
	fi
fi
