FROM  brunneis/python:3.7.7-ubuntu-18.04

RUN apt update && apt install  git vim build-essential wget -y 

RUN pip3 install --upgrade pip
RUN wget https://paddle-serving.bj.bcebos.com/test-dev/whl/paddle_serving_server_gpu-0.8.3.post102-py3-none-any.whl
RUN pip3 install paddle_serving_server_gpu-0.8.3.post102-py3-none-any.whl

RUN wget https://paddle-serving.bj.bcebos.com/test-dev/whl/paddle_serving_client-0.8.3-cp37-none-any.whl
RUN pip3 install paddle_serving_client-0.8.3-cp37-none-any.whl

RUN wget https://paddle-serving.bj.bcebos.com/test-dev/whl/paddle_serving_app-0.8.3-py3-none-any.whl
RUN pip3 install paddle_serving_app-0.8.3-py3-none-any.whl
RUN rm ./*.whl

RUN git clone https://github.com/paddlepaddle/PaddleOCR.git

RUN cd PaddleOCR && rm -rf .git/ .github/

COPY requirements.txt requirements.txt /
# 
RUN pip install  -r  requirements.txt -i https://mirror.baidu.com/pypi/simple
WORKDIR /PaddleOCR/deploy/pdserving/

# 下载并解压 OCR 文本检测模型
RUN wget https://paddleocr.bj.bcebos.com/PP-OCRv3/chinese/ch_PP-OCRv3_det_infer.tar -O ch_PP-OCRv3_det_infer.tar && tar -xf ch_PP-OCRv3_det_infer.tar
# 下载并解压 OCR 文本识别模型
RUN wget https://paddleocr.bj.bcebos.com/PP-OCRv3/chinese/ch_PP-OCRv3_rec_infer.tar -O ch_PP-OCRv3_rec_infer.tar &&  tar -xf ch_PP-OCRv3_rec_infer.tar

RUN rm -rf *.tar && rm -rf ~/.cache/pip


# 转换检测模型
RUN python3 -m paddle_serving_client.convert --dirname ./ch_PP-OCRv3_det_infer/ \
                                         --model_filename inference.pdmodel          \
                                         --params_filename inference.pdiparams       \
                                         --serving_server ./ppocr_det_v3_serving/ \
                                         --serving_client ./ppocr_det_v3_client/

# 转换识别模型
RUN python3 -m paddle_serving_client.convert --dirname ./ch_PP-OCRv3_rec_infer/ \
                                         --model_filename inference.pdmodel          \
                                         --params_filename inference.pdiparams       \
                                         --serving_server ./ppocr_rec_v3_serving/  \
                                         --serving_client ./ppocr_rec_v3_client/
RUN apt-get install -y libglib2.0-0 libsm6 libxrender1 libxext6
CMD [ "python web_service.py -c config.yml" ]
