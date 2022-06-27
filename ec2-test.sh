#!/usr/bin/fish

# gst-launch-1.0 \
#   videotestsrc pattern=snow ! \
#     video/x-raw,width=1280,height=720,framerate=15/1 ! \
#     videoscale ! videorate ! videoconvert ! timeoverlay ! \
#      vp8enc threads=6 deadline=2 error-resilient=1 ! \
#       rtpvp8pay ! udpsink host=192.168.86.3 port=5004




echo #### AUDIO is required ####

if not make
    echo make fail
    exit 1
end

## required!! will fail without audio
set -gx A "audiotestsrc is-live=true wave=red-noise ! audioconvert ! audioresample ! queue ! opusenc ! rtpopuspay pt=100 ssrc=1 ! queue ! application/x-rtp,media=audio,encoding-name=OPUS,payload=100"
set -gx V "videotestsrc pattern=smpte ! queue ! vp8enc   ! rtpvp8pay pt=96 ssrc=2 ! queue ! application/x-rtp,media=video,encoding-name=VP8,payload=96"
set -gx U https://mediaserver.whip.dev.omnivor.io/whip/endpoint/foo
#set -gx U http://192.168.86.3:7080/whip/endpoint/foo

GST_DEBUG=3,webrtc*:9,sctp*:9,dtls*:9 ./whip-client \
-u "$U" \
-V "$V" \
-A "$A" \
-S stun://stun.l.google.com:19302 -n


# ./whip-client \
# -u http://192.168.86.3:7080/whip/endpoint/foo \
# -V "videotestsrc pattern=snow ! video/x-raw,width=1280,height=720,framerate=30/1 !  videoscale ! videorate ! videoconvert ! timeoverlay ! vp8enc threads=6 deadline=2 target-bitrate=3000000   ! rtpvp8pay pt=96 ssrc=2 ! queue ! application/x-rtp,media=video,encoding-name=VP8,payload=96"