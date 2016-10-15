package edu.tufts.cs.imghostapp;

import android.app.Activity;
import android.content.Context;
import android.media.Image;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;

/**
 * Created by John on 10/14/16.
 */
public class EventArrayAdapter extends ArrayAdapter<Event> {

    private static final String TAG = "CODEARRAYADAPTER";
    private Context myContext;
    private int myResourceId;
    private ArrayList<Event> myEvents;

    public EventArrayAdapter(Context context, int resourceId, ArrayList<Event> events) {
        super(context, resourceId, events);
        myResourceId = resourceId;
        myContext = context;
        myEvents = events;
    }

    public View getView(int position, View convertView, ViewGroup parent) {

        Event event = myEvents.get(position);
        ViewHolder viewHolder;

        if (convertView == null) {
            convertView = LayoutInflater.from(this.getContext())
                    .inflate(R.layout.event_template, parent, false);
            viewHolder = new ViewHolder();
            viewHolder.eventImage = (ImageView) convertView.findViewById(R.id.event_image);
            viewHolder.codeText = (TextView) convertView.findViewById(R.id.event_code);
            viewHolder.titleText = (TextView) convertView.findViewById(R.id.event_title);
            convertView.setTag(viewHolder);
        } else {
            //Log.v(TAG, "ROW WASN'T NULL");
            viewHolder = (ViewHolder) convertView.getTag();
        }


        if (event != null) {
            //viewHolder.eventImage.setImageBitmap(event.getImage());
            viewHolder.titleText.setText(event.getTitle());
            viewHolder.codeText.setText(event.getCode());
        }


        return convertView;
    }

    static class ViewHolder {
        ImageView eventImage;
        TextView codeText;
        TextView titleText;
    }

}
