package edu.tufts.cs.imghostapp;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import java.io.ByteArrayOutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.content.SharedPreferences.Editor;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import org.json.JSONException;
import org.json.JSONObject;

public class Login extends AppCompatActivity {
    private static final String TAG = "LOGIN";

    private static final int CODE_LENGTH = 4;
    private static final String PREFS_NAME = "";
    private final String DELIMITER = ",";

    private EditText myNewCode;
    private FloatingActionButton myGoCodeButton;
    private FloatingActionButton myNewCodeButton;

    private ListView myCodeList;

    private ArrayList<Event> myEvents;
    private EventArrayAdapter myEventArrayAdapter;

    private List<String> myCodeStrings;


    private Context myContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        myContext = getApplicationContext();

        //CLEAR LOCAL STORAGE
/*
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        Editor editor = settings.edit();
        editor.putString("codes", "");
        editor.commit();*/

        //Fetch UI elements:
        myNewCode = (EditText) findViewById(R.id.newCode);
        myGoCodeButton = (FloatingActionButton) findViewById(R.id.goCodeButton);
        myNewCodeButton = (FloatingActionButton) findViewById(R.id.newCodeButton);
        myCodeList = (ListView) findViewById(R.id.code_list);

        //Fetch events from local storage:
        myEvents = new ArrayList<>();

        //Set Array Adapter for Event List View:
        myEventArrayAdapter = new EventArrayAdapter(this, R.layout.image_template, myEvents);
        myCodeList.setAdapter(myEventArrayAdapter);

        myCodeStrings = readCodesFromLocalStorage();

        populateEventList();

        myNewCodeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                myNewCode.setVisibility(View.VISIBLE);
                myNewCode.setEnabled(true);
                myNewCode.requestFocus();
            }
        });

        myNewCode.setVisibility(View.INVISIBLE);

        myNewCode.addTextChangedListener(new TextWatcher() {
            public void afterTextChanged(Editable s) {}

            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() == CODE_LENGTH) {
                    myGoCodeButton.setVisibility(View.VISIBLE);
                } else {
                    myGoCodeButton.setVisibility(View.INVISIBLE);
                }
            }
        });

        myGoCodeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                //TODO verify event code.
                String[] getParams = new String[]{("eventId=" + myNewCode.getText())};
                MakeRequest request = new MakeRequest("getEventInfo", getParams){
                    @Override
                    protected void onPostExecute (JSONObject result) {
                        try {
                            if (result != null && result.getInt("statusCode") == 200) {
                                writeCodeToLocalStorage(myNewCode.getText().toString());
                                myCodeStrings = readCodesFromLocalStorage();
                                populateEventList();

                                Intent i = new Intent(myContext, ViewImages.class);
                                i.putExtra("code", myNewCode.getText().toString());
                                myNewCode.setText("");
                                startActivity(i);
                            } else {
                                Animation shake = AnimationUtils.loadAnimation(Login.this, R.anim.shake);
                                final int originalFontColor = myNewCode.getCurrentTextColor();
                                shake.setAnimationListener(new Animation.AnimationListener(){
                                    @Override
                                    public void onAnimationStart(Animation arg0) {
                                        myNewCode.setTextColor(getResources().getColor(R.color.colorRed));
                                    }
                                    @Override
                                    public void onAnimationRepeat(Animation arg0) {
                                    }
                                    @Override
                                    public void onAnimationEnd(Animation arg0) {
                                        myNewCode.setTextColor(originalFontColor);
                                        myNewCode.setText("");
                                    }
                                });
                                myNewCode.startAnimation(shake);
                            }
                        } catch(JSONException e) {

                        }
                    }
                };
                request.execute();


            }
        });

        myCodeList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView parent, View v, int position, long id) {
                myNewCode.setText("");
                Intent intent = new Intent(v.getContext(), ViewImages.class);
                intent.putExtra("code", myEvents.get(position).getCode());
                startActivity(intent);
            }
        });

    }

    private void populateEventList() {
        myEvents.clear();
        myEventArrayAdapter.notifyDataSetChanged();
        //myEvents.add(new Event("CODE", "TITLE", null));
        for (String s : myCodeStrings) {
            if (!s.equals("")) {
                String [] getParams = new String [] {("eventId=" + s)};
                MakeRequest request = new MakeRequest("getEventInfo", getParams){
                    @Override
                    protected void onPostExecute(JSONObject result) {
                        try {
                            if (result != null && result.getInt("statusCode") == 200) {
                                if (result.getString("eventImage").equals("")) {
                                    myEvents.add(new Event(result.getString("eventId"),
                                            result.getString("name"), null));
                                } else {
                                    myEvents.add(new Event(result.getString("eventId"),
                                            result.getString("name"), new URL(result.getString("eventImage"))));
                                }

                                myEventArrayAdapter.notifyDataSetChanged();
                            }
                        } catch(JSONException e) {

                        } catch (MalformedURLException e) {
                            Log.v(TAG, "THERES A MALFORMED URL" + e.getMessage() + result.toString());
                        }
                    }
                };
                request.execute();
            }
        }
        if (myCodeStrings != null && myCodeStrings.size() == 0) {
            //TODO show "no events to show" message
        }
    }

    private void writeCodeToLocalStorage(String code) {
        if (!myCodeStrings.contains(code)) {
            SharedPreferences settings = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
            Editor editor = settings.edit();
            String existingCodes = settings.getString("codes", "");
            editor.putString("codes", "");
            editor.putString("codes", code + DELIMITER + existingCodes);
            editor.commit();
        }
    }

    private List<String> readCodesFromLocalStorage() {
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        String codeString = settings.getString("codes", "");
        List<String> codes = new ArrayList<>();
        if (codeString.equals("")) {
            return codes;
        }
        codes = Arrays.asList(codeString.split(DELIMITER));
        return codes;
    }
}
