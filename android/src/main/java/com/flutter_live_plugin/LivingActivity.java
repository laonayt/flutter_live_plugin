package com.flutter_live_plugin;

import android.content.DialogInterface;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;

import com.laifeng.sopcastsdk.configuration.AudioConfiguration;
import com.laifeng.sopcastsdk.configuration.CameraConfiguration;
import com.laifeng.sopcastsdk.configuration.VideoConfiguration;
import com.laifeng.sopcastsdk.stream.packer.rtmp.RtmpPacker;
import com.laifeng.sopcastsdk.stream.sender.rtmp.RtmpSender;
import com.laifeng.sopcastsdk.ui.CameraLivingView;


public class LivingActivity extends AppCompatActivity implements View.OnClickListener {
    private CameraLivingView mLFLiveView;
    private RtmpSender mRtmpSender;
    private ImageView closeIv;
    private ImageView startIv;
    private ImageView switchIv;
    private ImageView countDownIv;
    private TextView statusTv;
    private boolean isLiving;
    private VideoConfiguration mVideoConfiguration;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_living);

        initViews();
        initLiveView();
        countDown();
    }

    private void initViews() {
        mLFLiveView = (CameraLivingView) findViewById(R.id.liveView);
        closeIv = (ImageView) findViewById(R.id.iv_back);
        startIv = (ImageView) findViewById(R.id.iv_start);
        statusTv = (TextView) findViewById(R.id.tv_status);
        switchIv = (ImageView) findViewById(R.id.iv_switch);
        countDownIv = (ImageView) findViewById(R.id.iv_countdown);

        closeIv.setOnClickListener(this);
        switchIv.setOnClickListener(this);
        startIv.setOnClickListener(this);

        //弹幕Fragment
        BarrageFragment barrageFragment = new BarrageFragment();
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.add(R.id.barrage_content,barrageFragment,"barrageF").commit();
    }

    private void initLiveView() {
        mLFLiveView.init();

        //摄像头
        CameraConfiguration.Builder cameraBuilder = new CameraConfiguration.Builder();
        cameraBuilder.setOrientation(CameraConfiguration.Orientation.PORTRAIT).setFacing(CameraConfiguration.Facing.FRONT);
        CameraConfiguration cameraConfiguration = cameraBuilder.build();
        mLFLiveView.setCameraConfiguration(cameraConfiguration);

        //视频质量
        VideoConfiguration.Builder videoBuilder = new VideoConfiguration.Builder();
        videoBuilder.setSize(360, 640);
        mVideoConfiguration = videoBuilder.build();
        mLFLiveView.setVideoConfiguration(mVideoConfiguration);

        //初始化打包器
        RtmpPacker packer = new RtmpPacker();
        packer.initAudioParams(AudioConfiguration.DEFAULT_FREQUENCY, 16, false);
        mLFLiveView.setPacker(packer);

        //设置发送器
        String url = getIntent().getStringExtra("url");
        mRtmpSender = new RtmpSender();
        mRtmpSender.setAddress(url);
        mRtmpSender.setVideoParams(360, 640);
        mRtmpSender.setAudioParams(AudioConfiguration.DEFAULT_FREQUENCY, 16, false);
        mRtmpSender.setSenderListener(mSenderListener);
        mLFLiveView.setSender(mRtmpSender);
    }

    //倒计时
    private void countDown() {
        CountDownTimer timer = new CountDownTimer(5000, 1000) {
            public void onTick(long millisUntilFinished) {
                int index = (int) (millisUntilFinished/1000) + 1;
                switch (index) {
                    case 5:
                        countDownIv.setImageResource(R.mipmap.count_down_5);
                        break;
                    case 4:
                        countDownIv.setImageResource(R.mipmap.count_down_4);
                        break;
                    case 3:
                        countDownIv.setImageResource(R.mipmap.count_down_3);
                        break;
                    case 2:
                        countDownIv.setImageResource(R.mipmap.count_down_2);
                        break;
                    case 1:
                        countDownIv.setImageResource(R.mipmap.count_down_1);
                        break;
                }
            }

            public void onFinish() {
                countDownIv.setVisibility(View.INVISIBLE);
                //开始推流
                mRtmpSender.connect();
                mLFLiveView.start();
            }
        };
        timer.start();
    }

    private RtmpSender.OnSenderListener mSenderListener = new RtmpSender.OnSenderListener() {
        @Override
        public void onConnecting() {
            statusTv.setText("连接中...");
        }

        @Override
        public void onConnected() {
            statusTv.setText("已连接");
            startIv.setImageResource(R.mipmap.live_stop);
            isLiving = true;
        }

        @Override
        public void onDisConnected() {
            statusTv.setText("断开连接");
            startIv.setImageResource(R.mipmap.live_start);
            isLiving = false;
        }

        @Override
        public void onPublishFail() {
            statusTv.setText("推流失败");
            startIv.setImageResource(R.mipmap.live_start);
            isLiving = false;
        }

        @Override
        public void onNetGood() {}

        @Override
        public void onNetBad() {}
    };

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.iv_back) {
            AlertDialog.Builder build = new AlertDialog.Builder(this)
                    .setTitle("提示！")
                    .setMessage("退出直播间？")
                    .setPositiveButton("确定", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            mLFLiveView.stop();
                            mLFLiveView.release();
                            finish();
                        }
                    })
                    .setNegativeButton("取消", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                        }
                    });
            build.create().show();
        }
        else if (id == R.id.iv_switch) {
            mLFLiveView.switchCamera();
        }
        else if (id == R.id.iv_start) {
            if (isLiving == false) {
                mRtmpSender.connect();
                mLFLiveView.start();
            } else {
                mLFLiveView.stop();
                statusTv.setText("未连接");
                startIv.setImageResource(R.mipmap.live_start);
                isLiving = false;
            }
        }
    }
}
