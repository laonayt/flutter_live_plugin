package com.flutter_live_plugin;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class BarrageFragment extends Fragment {
    public List<BarrageBean> dataList = new ArrayList<>();
    private BarrageAdapter bAapter;
    //弹幕
    private RecyclerView recyclerView;

    //随机背景色
    private Random random = new Random();
    private int[] drawList = new int[]{
            R.drawable.rect_pink,
            R.drawable.rect_blue,
            R.drawable.rect_green,
            R.drawable.rect_yellow
    };

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_barrage, container, false);
        recyclerView = view.findViewById(R.id.recyclerView);

        //设置数据源
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        linearLayoutManager.setStackFromEnd(true);
        recyclerView.setLayoutManager(linearLayoutManager);

        bAapter = new BarrageAdapter(getContext(),dataList);
        recyclerView.setAdapter(bAapter);

        //注册eventbus
//        EventBus.getDefault().register(this);

        return view;

//        return super.onCreateView(inflater, container, savedInstanceState);
    }

//    @Subscribe(threadMode = ThreadMode.MAIN)
//    public void onMessageEvent(String msg) {
//        int randomIndex = random.nextInt(drawList.length);
//        int drawId = drawList[randomIndex];
//
//        BarrageBean bean = new BarrageBean(msg,drawId);
//        dataList.add(bean);
//
//        bAapter.notifyDataSetChanged();
//        recyclerView.smoothScrollToPosition(dataList.size() - 1);
//    };

    @Override
    public void onDestroy() {
        super.onDestroy();
//        EventBus.getDefault().unregister(this);
    }
}
