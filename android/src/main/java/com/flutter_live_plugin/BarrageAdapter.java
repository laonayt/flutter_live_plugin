package com.flutter_live_plugin;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;


public class BarrageAdapter extends RecyclerView.Adapter<BarrageAdapter.BarrageViewHolder> {
    private Context context;
    private List<BarrageBean> dataList;

    public BarrageAdapter(Context context, List<BarrageBean> dataList) {
        this.context = context;
        this.dataList = dataList;
    }

    @NonNull
    @Override
    public BarrageViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.barrage_item, parent, false);
        return new BarrageViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull BarrageViewHolder holder, int position) {
        BarrageBean bean = dataList.get(position);
        holder.title_tv.setText(bean.content);
        holder.title_tv.setBackgroundDrawable(ContextCompat.getDrawable(context, bean.drawId));
    }

    @Override
    public int getItemCount() {
        return dataList == null ? 0 : dataList.size();
    }

    public class BarrageViewHolder extends RecyclerView.ViewHolder {
        public TextView title_tv;

        public BarrageViewHolder(@NonNull View itemView) {
            super(itemView);
            title_tv = itemView.findViewById(R.id.title_tv);
        }
    }
}

