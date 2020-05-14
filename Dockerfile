FROM nvidia/cuda:9.0-base-ubuntu16.04

RUN apt update \
  && apt-get update \
  && apt install -y software-properties-common \
  && apt-get install -y vim curl

RUN apt-add-repository -y ppa:deadsnakes/ppa \
  && apt-get update \
  && apt-get install -y python3.6 python3-pip python-pip chrony ntpdate git \
  && ntpdate -q ntp.ubuntu.com

RUN git clone https://github.com/yehengchen/YOLOv3-ROS.git \
  && cd YOLOv3-ROS \
  && cp -r yolov3_pytorch_ros/ /root \
  && cd yolov3_pytorch_ros \
  && pip install --upgrade pip \
  && pip install -r requirements.txt

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y ros-kinetic-desktop-full
RUN apt-get install -y ros-kinetic-rqt
RUN apt-get install -y wget
RUN ["/bin/bash", "-c", "echo 'source /opt/ros/kinetic/setup.bash' >> ~/.bashrc;", "source ~/.bashrc"]
RUN apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential \
  && rosdep init \
  && rosdep update

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -

RUN pip install catkin_pkg

CMD tail -f /dev/null