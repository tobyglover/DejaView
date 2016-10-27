package edu.tufts.cs.listviewexample;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Last modified by John on 10/20/16.
 */
public class CustomArrayAdapter extends ArrayAdapter<ListViewItem> {
    private ArrayList<ListViewItem> items;

    public CustomArrayAdapter(Context context, ArrayList<ListViewItem> items) {
        super(context, 0, items);
        this.items = items;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ListViewItem item = items.get(position);
        ViewHolder viewHolder;
        if (convertView == null) {
            viewHolder = new ViewHolder();

            convertView = LayoutInflater.from(getContext())
                    .inflate(R.layout.listview_template, parent, false);

            viewHolder.textView = (TextView) convertView.findViewById(R.id.textView);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }

        if (item != null) {
            viewHolder.textView.setText(item.getText());
        }
        return convertView;
    }

    static class ViewHolder {
        TextView textView;
    }
}
