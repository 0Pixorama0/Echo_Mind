
/* ============================ STATE ============================ */
const KEY='ecomind_v1';
const MOODS={95:'😄',75:'🙂',55:'😐',35:'😔',15:'😣'};
const PERSONAS=[
  {name:'Therapist',emoji:'🧘',bg:'rgba(139,124,246,.16)',desc:'Calm, reflective, emotionally attuned.',tone:'warm'},
  {name:'Fitness Coach',emoji:'💪',bg:'rgba(94,230,192,.16)',desc:'Energetic, accountable, habit-driven.',tone:'energetic'},
  {name:'Productivity',emoji:'⚡',bg:'rgba(255,207,122,.16)',desc:'Focused, structured, momentum-building.',tone:'structured'},
  {name:'Nutrition',emoji:'🥗',bg:'rgba(94,230,192,.16)',desc:'Practical, balanced, non-judgmental.',tone:'practical'},
  {name:'Trading Mentor',emoji:'📈',bg:'rgba(91,141,239,.16)',desc:'Disciplined, risk-aware, analytical.',tone:'analytical'},
  {name:'Study Mentor',emoji:'📚',bg:'rgba(139,124,246,.16)',desc:'Patient, clear, exam-focused.',tone:'patient'},
  {name:'Business Advisor',emoji:'💼',bg:'rgba(255,207,122,.16)',desc:'Strategic, candid, growth-minded.',tone:'strategic'},
  {name:'Relationship',emoji:'💞',bg:'rgba(255,107,107,.14)',desc:'Warm, honest, perspective-giving.',tone:'warm'}
];
const THEME_WORDS=['work','deadline','sleep','walk','gym','family','money','health','food','screen','friend','meeting','project','review','launch','anxious','stress','tired','exercise','study','coffee'];

/* ---- guided journaling content ---- */
const GENERIC_FOLLOWUPS=[
  "Thank you for sharing that. What feelings come up as you say it?",
  "That's worth sitting with. What do you think is really driving it?",
  "If a good friend were in your shoes, what would you gently tell them?"
];
const MODES=[
  {id:'talk',emoji:'💬',bg:'rgba(139,124,246,.16)',title:'Talk it out',desc:'A gentle back-and-forth',opening:"I'm here, {name}. What's on your mind right now?",followups:GENERIC_FOLLOWUPS},
  {id:'checkin',emoji:'🌤️',bg:'rgba(91,141,239,.16)',title:'Daily check-in',desc:'A quick how-are-you',opening:"Let's check in, {name}. How are you feeling today — and what's behind it?",followups:["Thanks for naming that. What's contributing to it most?","What's one small thing that would make tomorrow a little lighter?"]},
  {id:'gratitude',emoji:'🙏',bg:'rgba(94,230,192,.16)',title:'Gratitude',desc:'Notice the good',opening:"Let's find some good today. What are three things — big or small — you're grateful for?",followups:["Lovely. Why does that one matter to you?","And who or what helped make that happen?"]},
  {id:'vent',emoji:'🌊',bg:'rgba(255,207,122,.16)',title:'Let it out',desc:'Vent, no filter',opening:"This is your space to let it all out, {name}. What's frustrating you? Don't hold back.",followups:["Get it all out — what else is sitting there?","That sounds heavy. What part stings the most?"]}
];
const PROMPTS=[
  "What's taking up the most space in your mind today?",
  "When did you feel most like yourself this week?",
  "What's one thing you've been avoiding — and why?",
  "What drained you today, and what restored you?",
  "What would make tomorrow feel like a win?",
  "What are you grateful for right now, however small?",
  "What's a worry you can set down tonight?",
  "Where did you show up well today?",
  "What do you need more of this week?",
  "What's something you've learned about yourself lately?"
];
const JOURNEYS=[
  {id:'calm',emoji:'🌙',title:'Calmer evenings',steps:[
    "Tonight, what's one thing keeping your mind busy? Let's name it.",
    "What helped you wind down today, even a little?",
    "What's a small ritual that could signal 'day's done' for you?",
    "How did your evening feel when you slowed down?",
    "What's one screen habit you'd like to soften this week?",
    "Looking back, what made your calmest evening calm?",
    "What will you carry forward into next week's nights?"]},
  {id:'stress',emoji:'🌿',title:'Ease work stress',steps:[
    "What at work is weighing on you most right now?",
    "Which part of that is actually in your control?",
    "When this week did work feel manageable — what was different?",
    "What's one boundary that would protect your energy?",
    "Who or what helps you reset after a hard day?"]},
  {id:'morning',emoji:'☀️',title:'Morning clarity',steps:[
    "What's the one thing that would make today feel good?",
    "How do you want to feel by tonight?",
    "What's a small win you can aim for before noon?",
    "What might pull you off track — and how will you handle it?",
    "What are you looking forward to today?"]}
];

/* ---- home dashboard content ---- */
const QUIPS=[
  {e:'🌱',t:"Your plants are judging you. Go water them."},
  {e:'💧',t:"You're 60% water and 100% doing your best. Sip up."},
  {e:'☕',t:"Coffee is a personality trait, and I respect yours."},
  {e:'🧎',t:"I saw that slouch. Sit up, superstar."},
  {e:'🗞️',t:"Breaking: overthinking still solved nothing. More at 11."},
  {e:'🎬',t:"Plot twist — the weekend is closer than your deadline."},
  {e:'🙌',t:"Your future self says thanks for showing up today."},
  {e:'📭',t:"Inbox zero is a myth. You're still my favorite."},
  {e:'🧠',t:"60,000 thoughts a day. Let's file a few of them."},
  {e:'🐢',t:"Slow progress is still progress. Ask any turtle."},
  {e:'✨',t:"You + this app = emotionally organized icon."},
  {e:'🔋',t:"You're not lazy, you're low battery. Recharge counts."}
];
const MOCK_EVENTS=[
  {t:'Team standup',h:9,m:30,loc:'Google Meet'},
  {t:'Design review',h:15,m:0,loc:'Meet · with Ravi & Neha'},
  {t:'1:1 with manager',h:17,m:0,loc:'Office · Room 3'}
];
const MOCK_MAILS=[
  {id:'m1',from:'Ravi Menon',subj:'Q3 budget — need your input',important:true,
   summary:'Can you approve the revised Q3 budget before Friday?',
   reply:'Hi Ravi, thanks for the revised numbers — they look good to me. Approved; please share with finance. Best, Aarav'},
  {id:'m2',from:'Neha (Design)',subj:'Quick feedback on the new flow?',important:false,
   summary:'Neha shared the updated onboarding flow and wants your take.',
   reply:'Hi Neha, the new flow is much cleaner — love the simplified first step. One thought: can we shorten the sign-up copy? Happy to jump on a call. Aarav'}
];
function fmtHM(h,m){const ap=h>=12?'PM':'AM';let hh=h%12;if(hh===0)hh=12;return hh+':'+(m<10?'0'+m:m)+' '+ap;}
function untilStr(mins){if(mins<60)return 'in '+mins+'m';const h=Math.floor(mins/60),mm=mins%60;return 'in '+h+'h'+(mm?' '+mm+'m':'');}
function nextEvent(){const now=new Date();const mins=now.getHours()*60+now.getMinutes();
  const up=MOCK_EVENTS.map(e=>Object.assign({},e,{abs:e.h*60+e.m})).filter(e=>e.abs>mins).sort((a,b)=>a.abs-b.abs);
  if(up.length)return Object.assign(up[0],{until:up[0].abs-mins,tomorrow:false});
  return Object.assign({},MOCK_EVENTS[0],{until:null,tomorrow:true});}

/* ---- per-persona dashboards ---- */
const PERSONA_KITS={
 'Therapist':{accent:'#8b7cf6',prompt:'How are you feeling today?',sub:"I'm here to listen and help you reflect.",
   bannerH:'Take a mindful moment',bannerP:'A quick check-in keeps your patterns clear.',
   logTitle:'Mood check-in',logVerb:'Check in',fWhat:{label:'A word for how you feel',ph:'calm, tense'},fVal:{label:'Calm level 0–100',ph:'70'},
   unit:'',metric:'Calm level',statA:'Avg calm',statB:'Check-ins',
   planTitle:"Today's care",plan:['Box breathing · 3 min','A 10-minute walk','Write one gratitude','Screens off by 10pm']},
 'Fitness Coach':{accent:'#5ee6c0',prompt:'Ready to move today?',sub:"Let's get the body going — your plan's below.",
   bannerH:'Log a workout',bannerP:'Every session counts. Keep the streak alive.',
   logTitle:'Log workout',logVerb:'Log workout',fWhat:{label:'Workout',ph:'Upper body'},fVal:{label:'Minutes',ph:'45'},
   unit:'min',metric:'Active minutes',statA:'Active min',statB:'Workouts',
   planTitle:"Today's workout",plan:['Warm-up · 5 min','Strength · 30 min','Core · 10 min','Cool-down stretch']},
 'Productivity':{accent:'#ffcf7a',prompt:"What's the one thing today?",sub:'Pick the needle-mover and protect your focus.',
   bannerH:'Log a focus session',bannerP:'Deep work adds up — track your focused time.',
   logTitle:'Log focus session',logVerb:'Log focus',fWhat:{label:'Task',ph:'Draft proposal'},fVal:{label:'Minutes',ph:'25'},
   unit:'min',metric:'Focus minutes',statA:'Focus min',statB:'Sessions',
   planTitle:"Today's focus",plan:['Define the #1 task','25-min deep work','Inbox to zero','Plan tomorrow']},
 'Nutrition':{accent:'#5ee6c0',prompt:'What are you fueling with?',sub:'Simple, balanced choices — no guilt.',
   bannerH:'Log a meal',bannerP:'Awareness first. Track what you eat and drink.',
   logTitle:'Log meal',logVerb:'Log meal',fWhat:{label:'Meal',ph:'Lunch — dal & rice'},fVal:{label:'Calories (approx)',ph:'450'},
   unit:'kcal',metric:'Calories',statA:'Calories 7d',statB:'Meals',
   planTitle:"Today's targets",plan:['2L water','Protein with each meal','5 servings of veg','No late-night snacking']},
 'Trading Mentor':{accent:'#5b8def',prompt:"What's the market telling you?",sub:'Discipline over impulse. Journal every trade.',
   bannerH:'Log a trade',bannerP:'Track P&L and the setup — learn from both.',
   logTitle:'Log trade',logVerb:'Log trade',fWhat:{label:'Symbol / setup',ph:'NIFTY breakout'},fVal:{label:'P&L (+/-)',ph:'1200'},
   unit:'₹',metric:'Daily P&L',statA:'Net P&L',statB:'Trades',
   planTitle:'Trading checklist',plan:['Set the stop-loss','Risk ≤ 2% per trade','No revenge trades','Journal the setup']},
 'Study Mentor':{accent:'#8b7cf6',prompt:'What are we learning today?',sub:'Small, steady sessions beat cramming.',
   bannerH:'Log a study session',bannerP:'Consistency compounds — track your minutes.',
   logTitle:'Log study session',logVerb:'Log study',fWhat:{label:'Subject',ph:'Calculus'},fVal:{label:'Minutes',ph:'40'},
   unit:'min',metric:'Study minutes',statA:'Study min',statB:'Sessions',
   planTitle:'Study plan',plan:['Revise yesterday','2 practice problems','Flashcards · 10 min','Summarize aloud']},
 'Business Advisor':{accent:'#ffcf7a',prompt:'What moves the needle today?',sub:'Focus on customers, shipping, and cash.',
   bannerH:'Log progress',bannerP:'Small wins compound — track your key actions.',
   logTitle:'Log a win',logVerb:'Log win',fWhat:{label:'What did you do?',ph:'Called 3 leads'},fVal:{label:'Impact 1–5',ph:'3'},
   unit:'',metric:'Impact score',statA:'Impact 7d',statB:'Actions',
   planTitle:'Growth checklist',plan:['Talk to 1 customer','Ship 1 thing','Review key metrics','Follow up 3 leads']},
 'Relationship':{accent:'#ff6b6b',prompt:'Who matters to you today?',sub:'Small gestures keep bonds strong.',
   bannerH:'Log a connection',bannerP:'Reaching out is the whole game — track it.',
   logTitle:'Log a connection',logVerb:'Log connect',fWhat:{label:'Who / how',ph:'Called Mom'},fVal:{label:'Warmth 1–5',ph:'4'},
   unit:'',metric:'Warmth',statA:'Warmth 7d',statB:'Connects',
   planTitle:'Reach out',plan:['Message a friend','Call family','Plan a date night','Express one thank-you']}
};
const PD_SEED={
 'Therapist':[['Calm',72,0],['Tense',55,1],['Steady',78,3],['Good',85,5]],
 'Fitness Coach':[['Upper body',45,0],['Morning run',30,1],['Leg day',50,3],['Yoga flow',25,4]],
 'Productivity':[['Proposal draft',50,0],['Deep work',25,1],['Email cleanup',20,2],['Weekly planning',30,4]],
 'Nutrition':[['Breakfast — oats',350,0],['Lunch — dal rice',520,0],['Dinner — grilled veg',430,1],['Snack — fruit',180,2]],
 'Trading Mentor':[['NIFTY breakout',1200,0],['Bank stop-out',-450,1],['Swing exit',900,3],['Scalp',300,4]],
 'Study Mentor':[['Calculus',40,0],['History notes',35,1],['Physics problems',50,2],['Revision',25,4]],
 'Business Advisor':[['Called 3 leads',4,0],['Shipped landing page',5,1],['Reviewed metrics',3,2],['Customer call',4,4]],
 'Relationship':[['Called Mom',5,0],['Coffee with Sam',4,1],['Texted Priya',3,3],['Date night',5,5]]
};
function seedPData(){const now=Date.now();const pd={};
  for(const name in PD_SEED){pd[name]={logs:PD_SEED[name].map((x,i)=>({id:now-i*1000,type:x[0],value:x[1],ts:now-x[2]*864e5})),checks:{}};}
  return pd;}
function kit(){return PERSONA_KITS[S.persona]||PERSONA_KITS['Therapist'];}
function getPD(name){name=name||S.persona;if(!S.pdata)S.pdata={};if(!S.pdata[name])S.pdata[name]={logs:[],checks:{}};return S.pdata[name];}
function hexA(h,a){h=h.replace('#','');return 'rgba('+parseInt(h.slice(0,2),16)+','+parseInt(h.slice(2,4),16)+','+parseInt(h.slice(4,6),16)+','+a+')';}
function pdStats(name){const pd=getPD(name);const now=Date.now();
  const wk=pd.logs.filter(l=>now-l.ts<7*864e5);
  const total=wk.reduce((a,l)=>a+(+l.value||0),0);
  const count=wk.length;
  const days=new Set(pd.logs.map(l=>dayKey(l.ts)));let streak=0;
  for(let i=0;i<400;i++){const d=new Date();d.setDate(d.getDate()-i);if(days.has(dayKey(d.getTime())))streak++;else if(i>0)break;else if(i===0)continue;}
  const prev=pd.logs.filter(l=>{const a=now-l.ts;return a>=7*864e5&&a<14*864e5;}).length;
  return {total,count,streak,delta:count-prev};}
function pdChart(name){const pd=getPD(name);const by={};pd.logs.forEach(l=>{const k=dayKey(l.ts);by[k]=(by[k]||0)+(+l.value||0);});
  const arr=[];for(let i=6;i>=0;i--){const d=new Date();d.setDate(d.getDate()-i);arr.push({lab:d.toLocaleDateString([],{weekday:'narrow'}),val:by[dayKey(d.getTime())]||0});}return arr;}
function renderPersonaDash(){
  const el=document.getElementById('personaDash');if(!el)return;
  const k=kit(),name=S.persona,p=persona(),acc=k.accent;
  const st=pdStats(name),chart=pdChart(name),pd=getPD(name);
  const isMoney=k.unit==='₹';
  const maxAbs=Math.max(1,...chart.map(c=>Math.abs(c.val)));
  const money=v=>(v<0?'-₹':'₹')+Math.abs(v);
  const totalDisp=isMoney?money(st.total):(st.total+(k.unit?' '+k.unit:''));
  const bars=chart.map(c=>{const h=c.val?Math.max(Math.round(Math.abs(c.val)/maxAbs*100),4):2;const col=c.val<0?'var(--rose)':acc;
    return '<div class="bar"><div class="fill" data-h="'+h+'%" style="height:0%;background:'+col+'"></div><small>'+c.lab+'</small></div>';}).join('');
  const plan=k.plan.map(item=>{const on=pd.checks[item];
    return '<div class="plan-row '+(on?'on':'')+'" onclick="togglePlan('+JSON.stringify(item).replace(/"/g,'&quot;')+')"><div class="pchk" style="'+(on?'background:'+acc:'')+'">'+(on?'<svg width="12" height="12" viewBox="0 0 24 24" fill="none"><path d="M5 12l5 5L20 6" stroke="#0a0a10" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg>':'')+'</div><span>'+esc(item)+'</span></div>';}).join('');
  const recent=pd.logs.slice().sort((a,b)=>b.ts-a.ts).slice(0,3).map(l=>{
    const v=isMoney?money(l.value):(l.value+(k.unit?' '+k.unit:''));const col=isMoney?(l.value<0?'var(--rose)':'var(--mint)'):acc;
    return '<div class="pd-log-item"><span class="pv" style="color:'+col+'">'+esc(v)+'</span><span class="pn">'+esc(l.type)+'</span><span class="pw">'+esc(fmtWhen(l.ts).split(' · ')[0])+'</span></div>';
  }).join('')||'<div class="empty">No entries yet — tap '+esc(k.logVerb)+' above.</div>';
  el.innerHTML=
   '<div class="pd-head"><div class="pdi" style="background:'+p.bg+'">'+p.emoji+'</div><div><h3>'+esc(name)+'</h3><small>your '+esc(name.toLowerCase())+' space</small></div></div>'+
   '<div class="pd-banner" style="background:linear-gradient(150deg,'+hexA(acc,.22)+','+hexA(acc,.05)+');border:1px solid '+hexA(acc,.3)+'"><div class="pbt"><h4>'+esc(k.bannerH)+'</h4><p>'+esc(k.bannerP)+'</p></div><button class="pd-log" style="background:'+acc+'" onclick="openSheet(\'log\')">'+esc(k.logVerb)+'</button></div>'+
   '<div class="bento">'+stat(esc(''+totalDisp),'',acc,k.statA)+stat(st.count,'',acc,k.statB)+stat(st.streak,st.streak===1?'day':'days',acc,'Streak')+stat((st.delta>=0?'+'+st.delta:''+st.delta),'','#3fb8e6','vs last wk')+'</div>'+
   '<div class="pd-chart-wrap"><div class="pcl"><span>'+esc(k.metric)+' · last 7 days</span></div><div class="bars">'+bars+'</div></div>'+
   '<div class="section-label">'+esc(k.planTitle)+'</div><div class="card">'+plan+'</div>'+
   '<div class="section-label">Recent</div><div class="card">'+recent+'</div>';
  setTimeout(()=>el.querySelectorAll('.bars .fill').forEach((f,i)=>setTimeout(()=>{f.style.height=f.dataset.h;},50+i*55)),40);
}
function submitLog(){const k=kit();const what=(document.getElementById('logWhat').value||'').trim();const raw=(document.getElementById('logVal').value||'').trim();
  if(!what){toast('Add a short description');return;}
  let val=parseFloat(raw.replace(/[^0-9.\-]/g,''));if(isNaN(val))val=1;
  getPD().logs.push({id:Date.now(),type:what,value:val,ts:Date.now()});save();renderPersonaDash();closeSheet();toast(k.logTitle+' saved ✓');}
function togglePlan(item){const pd=getPD();pd.checks[item]=!pd.checks[item];save();renderPersonaDash();}

let S; let G=null;
function fresh(){
  const now=Date.now(),D=864e5;
  return {
    consent:false, name:'Aarav', persona:'Therapist',
    settings:{voice:false, reminders:false},
    aiDisabled:false,
    entries:[
      {id:1,text:"Shipped the release today. Long day but the launch went smoothly and I felt proud of the team. I really need to actually rest this weekend.",mood:75,ts:now-2*3600e3,level:1},
      {id:2,text:"Anxious about the review tomorrow. Couldn't focus much, kept checking messages. Went for a walk which helped a bit.",mood:35,ts:now-1*D,level:1},
      {id:3,text:"Good morning routine — woke early, no phone for the first hour, felt clear and calm heading into work.",mood:75,ts:now-3*D,level:1},
      {id:4,text:"Deadlines piling up at work. Barely slept. Feeling stretched thin but pushing through with coffee.",mood:35,ts:now-4*D,level:1},
      {id:5,text:"Gym in the morning then dinner with family. A genuinely good, balanced day.",mood:95,ts:now-5*D,level:1}
    ],
    tasks:[{id:1,text:'Rest this weekend — no laptop',done:false},{id:2,text:'Prep notes for the review',done:true}],
    reminders:[{id:1,time:'10:00 PM',text:'Wind down — screens off',done:false},{id:2,time:'8:00 AM',text:'Call the bank about the card',done:false}],
    mailReplied:[], journeys:{}, pdata:seedPData(), chat:[]
  };
}
function load(){ try{S=JSON.parse(localStorage.getItem(KEY))||fresh();}catch(e){S=fresh();}
  // AI-pause is per-session only (SOW): a fresh app load re-enables the AI so the app is never permanently stuck.
  if(S){S.aiDisabled=false; if(!S.journeys)S.journeys={}; if(!S.mailReplied)S.mailReplied=[]; if(!S.pdata)S.pdata=seedPData();
    if(!S.reminders)S.reminders=[{id:1,time:'10:00 PM',text:'Wind down — screens off',done:false},{id:2,time:'8:00 AM',text:'Call the bank about the card',done:false}];} }
function save(){ localStorage.setItem(KEY,JSON.stringify(S)); }
load();

/* ============================ NAV ============================ */
function go(view){
  document.querySelectorAll('.view').forEach(v=>v.classList.toggle('active',v.dataset.view===view));
  document.querySelectorAll('.tab').forEach(t=>t.classList.toggle('on',t.dataset.tab===view));
  const el=document.querySelector('.view[data-view="'+view+'"]'); if(el)el.scrollTop=0;
  if(view==='insights') setTimeout(renderInsights,60);
  if(view==='home') renderHome();
  if(view==='journal') renderJournal();
  if(view==='settings') renderSettings();
}

/* ============================ SAFETY CLASSIFIER ============================ */
const L3=/(kill myself|kill me|suicid|end my life|end it all|want to die|better off dead|hurt myself|harm myself|no reason to live|cant go on|can't go on|take my life)/i;
const L2=/(worthless|hopeless|hate myself|feel empty|so numb|numb inside|cant cope|can't cope|breaking down|nothing matters|no point|whats the point|what's the point|burnt out|burned out|exhausted all the time|cant do this anymore|can't do this anymore)/i;
function classify(text){ if(L3.test(text))return 3; if(L2.test(text))return 2; return 1; }

/* ============================ HELPERS ============================ */
function dayKey(ts){const d=new Date(ts);return d.getFullYear()+'-'+d.getMonth()+'-'+d.getDate();}
function fmtWhen(ts){
  const d=new Date(ts),now=new Date(),diff=(now-d)/864e5;
  const t=d.toLocaleTimeString([],{hour:'numeric',minute:'2-digit'});
  if(dayKey(ts)===dayKey(now.getTime()))return 'Today · '+t;
  if(diff<2)return 'Yesterday · '+t;
  return d.toLocaleDateString([],{weekday:'short'})+' · '+t;
}
function moodColor(m){return m>=85?'#5ee6c0':m>=65?'#8b7cf6':m>=45?'#5b8def':m>=25?'#ffcf7a':'#ff6b6b';}
function titleFromText(t){const s=t.trim().split(/[.!?\n]/)[0];return s.length>42?s.slice(0,42)+'…':s||'Journal entry';}
function persona(){return PERSONAS.find(p=>p.name===S.persona)||PERSONAS[0];}
function avgMood(days){
  const cut=Date.now()-days*864e5;
  const es=S.entries.filter(e=>e.ts>=cut);
  if(!es.length)return null;
  return Math.round(es.reduce((a,e)=>a+e.mood,0)/es.length);
}
function streak(){
  let n=0;const seen=new Set(S.entries.map(e=>dayKey(e.ts)));
  for(let i=0;i<400;i++){const d=new Date();d.setDate(d.getDate()-i);
    if(seen.has(dayKey(d.getTime())))n++; else if(i>0)break; else if(i===0)continue;}
  return n;
}
function themeCounts(){
  const c={};S.entries.forEach(e=>{const low=e.text.toLowerCase();
    THEME_WORDS.forEach(w=>{if(low.includes(w))c[w]=(c[w]||0)+1;});});
  return Object.entries(c).sort((a,b)=>b[1]-a[1]);
}

/* ============================ RENDER ============================ */
function renderChrome(){
  document.getElementById('avatar').textContent=(S.name[0]||'A').toUpperCase();
  const p=persona();
  document.getElementById('personaName').textContent=p.name;
  document.getElementById('personaDot').textContent=p.emoji;
  document.getElementById('chatPersona').textContent=p.name;
  const d=new Date();
  document.getElementById('todayDate').textContent=d.toLocaleDateString([],{weekday:'long',day:'numeric',month:'long'});
  const h=d.getHours();const part=h<12?'morning':h<17?'afternoon':'evening';
  document.getElementById('greetLine').innerHTML='Good '+part+',<br>'+S.name;
  document.getElementById('clock').textContent=d.toLocaleTimeString([],{hour:'numeric',minute:'2-digit'}).replace(/\s?[AP]M/i,'');
}
function renderHome(){
  renderChrome();
  const avg=avgMood(7), st=streak();
  const arc=document.getElementById('ringArc');
  if(avg!=null){
    arc.style.strokeDashoffset=195-(195*avg/100);
    document.getElementById('ringVal').textContent=avg;
    const label=avg>=75?'Feeling good ☀️':avg>=55?'Mostly steady 🌤️':avg>=35?'A heavier stretch 🌥️':'Running low 🌧️';
    document.getElementById('moodTitle').textContent=label;
    document.getElementById('moodDesc').textContent=st>0?(st+'-day journaling streak. '+(avg>=55?'You\'re recovering well.':'Be gentle with yourself today.')):'Tap to see your weekly patterns.';
  }
  // persona-themed hero + dashboard
  const k=kit();
  const hp=document.getElementById('heroPrompt');if(hp)hp.textContent=k.prompt;
  const hs=document.getElementById('heroSub');if(hs)hs.textContent=k.sub;
  const orb=document.getElementById('homeOrb');if(orb)orb.style.boxShadow='0 0 60px -4px '+hexA(k.accent,.75)+', inset 0 -8px 24px rgba(0,0,0,.25), inset 0 6px 16px rgba(255,255,255,.35)';
  renderPersonaDash();
  renderBriefing();renderUpNext();renderMail();renderReminders();renderOnThisDay();
  // tasks
  const tc=document.getElementById('homeTasks');
  const open=S.tasks;
  tc.innerHTML = open.length? open.map(t=>taskRow(t)).join('') : '<div class="empty">No tasks yet. Add one, or I\'ll pull action items from your journal.</div>';
  // suggestion
  const themes=themeCounts();
  if(st>1){document.getElementById('suggTitle').textContent='You\'re on a '+st+'-day streak 🔥';document.getElementById('suggBody').textContent='Consistency is what lets me spot the patterns behind your mood. Keep it going tonight.';}
  else if(themes.length){document.getElementById('suggTitle').textContent='"'+themes[0][0]+'" keeps coming up';document.getElementById('suggBody').textContent='It appears in '+themes[0][1]+' of your entries. Want to reflect on it with your '+persona().name+'?';}
}
function taskRow(t){
  return '<div class="task '+(t.done?'done':'')+'"><div class="check '+(t.done?'on':'')+'" onclick="toggleTask('+t.id+')">'+(t.done?'<svg width="12" height="12" viewBox="0 0 24 24" fill="none"><path d="M5 12l5 5L20 6" stroke="#fff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg>':'')+'</div><span>'+esc(t.text)+'</span></div>';
}
/* ---- home dashboard renders ---- */
function newQuip(){const el=document.getElementById('quip');if(!el)return;
  const q=QUIPS[Math.floor(Math.random()*QUIPS.length)];
  el.innerHTML='<span class="qe">'+q.e+'</span><span>'+q.t+'</span>';}
function renderBriefing(){const el=document.getElementById('briefing');if(!el)return;
  const h=new Date().getHours();const part=h<12?'Morning':h<17?'Afternoon':'Evening';
  const mails=MOCK_MAILS.filter(m=>!(S.mailReplied||[]).includes(m.id)).length;
  const tasksLeft=S.tasks.filter(t=>!t.done).length;
  const ev=nextEvent();const avg=avgMood(7);
  let bits=[];
  if(ev)bits.push(ev.tomorrow?('first up tomorrow is <b>'+ev.t+'</b> at '+fmtHM(ev.h,ev.m)):('<b>'+ev.t+'</b> at '+fmtHM(ev.h,ev.m)));
  if(mails)bits.push('<b>'+mails+' email'+(mails>1?'s':'')+'</b> to reply to');
  if(tasksLeft)bits.push('<b>'+tasksLeft+' task'+(tasksLeft>1?'s':'')+'</b> open');
  let sentence;
  if(!bits.length)sentence="you're all caught up. A rare, beautiful thing — enjoy it.";
  else if(bits.length===1)sentence="you've got "+bits[0]+".";
  else sentence="you've got "+bits.slice(0,-1).join(', ')+", and "+bits[bits.length-1]+".";
  const tip=avg!=null?(avg>=60?" Your calmer days start with an early walk — maybe carve out 20 minutes.":" Yesterday ran heavy; be a little gentle with today."):"";
  el.innerHTML='<div class="briefing"><span class="bt">☀️ Your '+part.toLowerCase()+' briefing</span><p>'+part+', '+esc(S.name)+' — '+sentence+tip+'</p></div>';}
function renderUpNext(){const el=document.getElementById('upNext');if(!el)return;const e=nextEvent();
  const cd=e.tomorrow?'tomorrow':untilStr(e.until);const parts=fmtHM(e.h,e.m).split(' ');
  el.innerHTML='<div class="upnext"><div class="ut"><b>'+parts[0]+'</b><small>'+parts[1]+'</small></div><div class="ui"><h4>'+esc(e.t)+'</h4><p>'+esc(e.loc)+'</p></div><div class="cd">'+cd+'</div></div>';}
function renderMail(){const el=document.getElementById('mailList');if(!el)return;
  const list=MOCK_MAILS.filter(m=>!(S.mailReplied||[]).includes(m.id));
  const cnt=document.getElementById('mailCount');if(cnt)cnt.textContent=list.length?(list.length+' waiting'):'all clear';
  el.innerHTML=list.length?list.map(m=>{
    const ini=m.from.split(' ').map(x=>x[0]).slice(0,2).join('');
    const col=m.important?'linear-gradient(135deg,#ffcf7a,#f2994a)':'linear-gradient(135deg,#8b7cf6,#6366f1)';
    return '<div class="mail" onclick="openMail(\''+m.id+'\')"><div class="mav" style="background:'+col+'">'+esc(ini)+'</div><div class="mb"><div class="mh"><h4>'+esc(m.from)+'</h4>'+(m.important?'<span class="imp">Important</span>':'')+'</div><p>'+esc(m.subj)+' — '+esc(m.summary)+'</p></div></div>';
  }).join(''):'<div class="empty">Inbox is calm. Nothing needs a reply right now. 🌿</div>';}
function renderReminders(){const el=document.getElementById('reminderList');if(!el)return;
  const list=(S.reminders||[]).filter(r=>!r.done);
  el.innerHTML=list.length?list.map(r=>'<div class="rem"><span class="rt">'+esc(r.time)+'</span><span class="rtx">'+esc(r.text)+'</span><span class="rx" onclick="dismissReminder('+r.id+')">✓</span></div>').join(''):'<div class="empty">No reminders set. Tap “+ Add” to create one.</div>';}
function renderOnThisDay(){const el=document.getElementById('onThisDay');if(!el)return;
  const now=Date.now();const old=S.entries.filter(e=>now-e.ts>=3*864e5).sort((a,b)=>a.ts-b.ts);
  const e=old[0]||S.entries.slice().sort((a,b)=>a.ts-b.ts)[0];
  if(!e){el.innerHTML='<div class="empty">Your memories will appear here as you journal.</div>';return;}
  const days=Math.max(1,Math.round((now-e.ts)/864e5));
  el.innerHTML='<div class="otd"><div class="ot">🕰️ '+days+' day'+(days>1?'s':'')+' ago</div><h3>You wrote…</h3><p>“'+esc(titleFromText(e.text))+'”</p><button class="btn sm" onclick="reflectOn('+e.id+')">How does that feel now?</button></div>';}
function openMail(id){const m=MOCK_MAILS.find(x=>x.id===id);if(!m)return;
  const t=document.getElementById('sheetTitle'),s=document.getElementById('sheetSub'),f=document.getElementById('sheetFields'),btn=document.getElementById('sheetSave');
  t.textContent=m.from;s.textContent=m.subj;btn.style.background='';
  f.innerHTML='<div style="font-size:13px;color:var(--muted);line-height:1.5;margin-bottom:14px;background:var(--surface2);border:1px solid var(--border);border-radius:12px;padding:12px">'+esc(m.summary)+'</div><div style="font-size:11px;font-weight:700;color:var(--violet);text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px">✦ Suggested reply</div><textarea id="mailReply">'+esc(m.reply)+'</textarea>';
  btn.textContent='Send reply';btn.onclick=function(){sendMail(id);};
  document.getElementById('sheetBack').classList.add('open');document.getElementById('sheet').classList.add('open');}
function sendMail(id){S.mailReplied=S.mailReplied||[];if(!S.mailReplied.includes(id))S.mailReplied.push(id);save();closeSheet();renderHome();toast('Reply sent ✓ (demo)');}
function submitReminder(){const tm=(document.getElementById('remTime').value||'').trim()||'Today';const tx=(document.getElementById('remText').value||'').trim();
  if(!tx){toast('What should I remind you?');return;}S.reminders.push({id:Date.now(),time:tm,text:tx,done:false});save();renderHome();closeSheet();toast('Reminder set ✓');}
function dismissReminder(id){const r=S.reminders.find(x=>x.id===id);if(r){r.done=true;save();renderHome();toast('Reminder done ✓');}}
function todaysPromptIdx(){return Math.floor(Date.now()/864e5)%PROMPTS.length;}
function renderDailyPrompt(){
  const el=document.getElementById('dailyPrompt');if(!el)return;
  const q=PROMPTS[todaysPromptIdx()];
  el.innerHTML='<div class="prompt-card"><span class="pl">✦ Today\'s prompt</span><h3>'+esc(q)+'</h3>'+
    '<button class="btn sm" onclick="startDailyPrompt()">Reflect on this</button></div>';
}
function startDailyPrompt(){startReflection(PROMPTS[todaysPromptIdx()],null,"Today's prompt");}
function renderModes(){
  const el=document.getElementById('modeGrid');if(!el)return;
  el.innerHTML=MODES.map(m=>'<div class="mode" onclick="startMode(\''+m.id+'\')"><div class="mi" style="background:'+m.bg+'">'+m.emoji+'</div><h4>'+m.title+'</h4><p>'+m.desc+'</p></div>').join('');
}
function renderJourneys(){
  const el=document.getElementById('journeys');if(!el)return;
  const prog=S.journeys||{};
  el.innerHTML=JOURNEYS.map(j=>{
    const done=Math.min(prog[j.id]||0,j.steps.length);const pct=Math.round(done/j.steps.length*100);
    const label=done>=j.steps.length?'Completed 🎉':'Day '+(done+1)+' of '+j.steps.length;
    return '<div class="journey" onclick="startJourney(\''+j.id+'\')"><div class="je">'+j.emoji+'</div><h4>'+j.title+'</h4><div class="jbar"><i style="width:'+pct+'%"></i></div><small>'+label+'</small></div>';
  }).join('');
}
function renderJournal(){
  renderDailyPrompt();renderModes();renderJourneys();
  const list=document.getElementById('entryList');
  list.innerHTML = S.entries.length? S.entries.slice().sort((a,b)=>b.ts-a.ts).map(e=>{
    const lvl=e.level>=3?'<span class="lvl l3">Crisis</span>':e.level===2?'<span class="lvl l2">Support</span>':'';
    return '<div class="entry" onclick="reflectOn('+e.id+')"><span class="mdot" style="background:'+moodColor(e.mood)+'"></span><div class="body"><h4>'+MOODS[e.mood]+' '+esc(titleFromText(e.text))+lvl+'</h4><p>'+esc(e.text)+'</p><div class="when">'+fmtWhen(e.ts)+'</div></div></div>';
  }).join('') : '<div class="empty">No entries yet — write your first above.</div>';
  // weekly reflection
  const wr=document.getElementById('weeklyReflect');
  const avg=avgMood(7),themes=themeCounts();
  if(avg!=null&&S.entries.length>=2){
    const top=themes.slice(0,2).map(t=>t[0]).join(' and ');
    wr.textContent=(avg>=60?'A mostly steady week.':'A demanding week.')+(top?' '+cap(top)+' shaped most of your entries.':'')+' Your calm score is averaging '+avg+'/100.';
  }
}
function renderInsights(){
  // bars: last 7 days
  const bars=document.getElementById('bars');bars.innerHTML='';
  const byDay={};S.entries.forEach(e=>{const k=dayKey(e.ts);(byDay[k]=byDay[k]||[]).push(e.mood);});
  for(let i=6;i>=0;i--){
    const d=new Date();d.setDate(d.getDate()-i);
    const arr=byDay[dayKey(d.getTime())];
    const val=arr?Math.round(arr.reduce((a,b)=>a+b,0)/arr.length):0;
    const lab=d.toLocaleDateString([],{weekday:'narrow'});
    const div=document.createElement('div');div.className='bar';
    div.innerHTML='<div class="fill" style="height:0%"></div><small>'+lab+'</small>';
    bars.appendChild(div);
    const f=div.querySelector('.fill');
    setTimeout(()=>{f.style.height=(val?Math.max(val,6):3)+'%';if(!val)f.style.opacity='.25';},80+((6-i)*70));
  }
  // stats
  const avg=avgMood(7),prev=(function(){const cut1=Date.now()-14*864e5,cut2=Date.now()-7*864e5;const es=S.entries.filter(e=>e.ts>=cut1&&e.ts<cut2);return es.length?Math.round(es.reduce((a,e)=>a+e.mood,0)/es.length):null;})();
  const st=streak();
  const highStress=(function(){const byDay={};S.entries.forEach(e=>{const k=dayKey(e.ts);(byDay[k]=byDay[k]||[]).push(e.mood);});return Object.values(byDay).filter(a=>a.reduce((x,y)=>x+y,0)/a.length<40).length;})();
  const delta=(avg!=null&&prev!=null)?(avg-prev):null;
  document.getElementById('statBento').innerHTML=
    stat((avg!=null?avg:'–'),'/100','#5ee6c0','Avg calm (7d)')+
    stat(st,st===1?'day':'days','#8b7cf6','Journal streak')+
    stat((delta!=null?(delta>=0?'+'+delta:delta):'–'),'%','#3fb8e6','vs prev week')+
    stat(highStress,'','#ffcf7a','High-stress days');
  // themes
  const themes=themeCounts();
  document.getElementById('themeChips').innerHTML = themes.length? themes.slice(0,8).map(t=>'<span class="chip">'+cap(t[0])+'<span class="n">'+t[1]+'</span></span>').join('') : '<div class="empty">Themes appear as you journal more.</div>';
  // pattern
  if(themes.length){document.getElementById('patTitle').textContent=cap(themes[0][0])+' is your top theme';document.getElementById('patBody').textContent='It shows up most across your entries'+(highStress?', and clusters around your higher-stress days. A small change there could smooth your week.':'. Worth reflecting on where it helps vs. drains you.');}
}
function stat(v,u,c,l){return '<div class="stat"><b>'+v+'<span class="u">'+u+'</span></b><small><span class="dot" style="background:'+c+'"></span>'+l+'</small></div>';}
function renderPersonas(){
  document.getElementById('pgrid').innerHTML=PERSONAS.map(p=>
    '<div class="pcard '+(p.name===S.persona?'on':'')+'" onclick="pickPersona(\''+p.name+'\')"><span class="badge">Active</span><div class="pic" style="background:'+p.bg+'">'+p.emoji+'</div><h4>'+p.name+'</h4><p>'+p.desc+'</p></div>'
  ).join('');
}
function renderSettings(){
  document.getElementById('nameInput').value=S.name;
  document.getElementById('swVoice').classList.toggle('on',S.settings.voice);
  document.getElementById('swRem').classList.toggle('on',S.settings.reminders);
}
function esc(s){return (s+'').replace(/[&<>"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));}
function cap(s){return s.charAt(0).toUpperCase()+s.slice(1);}

/* ============================ JOURNAL ACTIONS ============================ */
let selMood=75;
document.getElementById('moodpick').addEventListener('click',e=>{const m=e.target.closest('.me');if(!m)return;
  document.querySelectorAll('#moodpick .me').forEach(x=>x.classList.remove('sel'));m.classList.add('sel');selMood=+m.dataset.s;});
function saveEntry(reflect){
  const ta=document.getElementById('entryText');const text=ta.value.trim();
  if(!text){toast('Write something first');return;}
  const level=classify(text);
  const entry={id:Date.now(),text,mood:level>=2?Math.min(selMood,35):selMood,ts:Date.now(),level};
  S.entries.push(entry);
  // auto extract a task from "need to / have to / should"
  const m=text.match(/(?:need to|have to|should|must|remember to)\s+([^.!?\n]{3,60})/i);
  if(m){S.tasks.push({id:Date.now()+1,text:cap(m[1].trim()),done:false});toast('Added a task from your entry ✓');}
  save();ta.value='';renderJournal();renderHome();
  if(level>=3){entry.mood=15;save();openCrisis();return;}
  if(reflect){openChat();setTimeout(()=>aiRespondTo(text,level,true),400);}
  else toast(level===2?'Saved — I\'m here if you want to talk':'Entry saved ✓');
}
function reflectOn(id){const e=S.entries.find(x=>x.id===id);if(!e)return;openChat();
  pushMsg('me',e.text);setTimeout(()=>aiRespondTo(e.text,e.level,false),400);}

/* ============================ TASKS ============================ */
function toggleTask(id){const t=S.tasks.find(x=>x.id===id);if(!t)return;t.done=!t.done;save();renderHome();}

/* ============================ PERSONAS ============================ */
function pickPersona(name){S.persona=name;save();renderPersonas();renderChrome();
  toast(name+' is now active');setTimeout(()=>go('home'),260);}

/* ============================ SETTINGS ============================ */
function setName(v){S.name=v.trim()||'friend';save();renderChrome();toast('Name updated');}
function toggleSetting(k,el){S.settings[k]=!S.settings[k];el.classList.toggle('on',S.settings[k]);save();
  if(k==='voice')toast(S.settings.voice?'Spoken replies on':'Spoken replies off');
  if(k==='reminders')toast(S.settings.reminders?'Wind-down reminder set for 9:45pm':'Reminder off');}
function exportData(){
  const blob=new Blob([JSON.stringify(S,null,2)],{type:'application/json'});
  const url=URL.createObjectURL(blob);const a=document.createElement('a');
  a.href=url;a.download='ecomind-data.json';a.click();URL.revokeObjectURL(url);toast('Exported ecomind-data.json');
}
function wipeData(){
  openSheet('wipe');
}

/* ============================ CHAT + AI ============================ */
function openChat(){G=null;setGuidedUI();document.getElementById('chatStatus').textContent='online';
  document.getElementById('chatOverlay').classList.add('open');renderChat();applyAiState();
  document.getElementById('chatBody').scrollTop=1e6;}
function talkFree(){openChat();}
function closeChat(){document.getElementById('chatOverlay').classList.remove('open');stopVoice();G=null;setGuidedUI();}
function setGuidedUI(){const b=document.getElementById('guidedSave');if(b)b.style.display=(G&&!S.aiDisabled)?'block':'none';}
function renderChat(){
  const b=document.getElementById('chatBody');
  if(!S.chat.length && !G){
    S.chat.push({r:'ai',t:persona().name==='Therapist'?"Hey "+S.name+". I'm here whenever you want to think out loud. How are you feeling right now?":"Hi "+S.name+" — your "+persona().name+" here. What's on your mind?"});
    save();
  }
  b.innerHTML='<div class="disc">EcoMind offers reflection and support — it is not a substitute for professional care.</div>'+
    S.chat.map(m=>{
      let x='';
      if(m.act==='resources')x='<br><span class="res" onclick="openCrisis()">View support resources</span>';
      else if(m.act==='save')x='<br><span class="res save" onclick="saveGuidedReflection()">Save reflection ✓</span>';
      return '<div class="msg '+(m.r)+'">'+esc(m.t)+x+'</div>';
    }).join('');
  b.scrollTop=1e6;
}
function pushMsg(r,t,act){S.chat.push({r,t,act:(act===true?'resources':(act||null))});save();renderChat();}
function applyAiState(){
  const bar=document.getElementById('chatInputBar');const paused=document.getElementById('aiPaused');
  if(S.aiDisabled){bar.style.display='none';setGuidedUI();
    if(!paused){const d=document.createElement('div');d.className='ai-paused';d.id='aiPaused';
      d.innerHTML='AI paused for your safety. Please reach out to someone who can help — resources are one tap away above. 💛';
      bar.parentNode.appendChild(d);}
  }else{bar.style.display='';if(paused)paused.remove();}
}
function typing(cb,reply){
  const b=document.getElementById('chatBody');
  const ty=document.createElement('div');ty.className='typing';ty.id='typing';ty.innerHTML='<i></i><i></i><i></i>';b.appendChild(ty);b.scrollTop=1e6;
  setTimeout(()=>{const t=document.getElementById('typing');if(t)t.remove();cb();},600+Math.min(reply.length*11,1200));
}
function sendMsg(){
  const f=document.getElementById('chatField');const t=f.value.trim();if(!t||S.aiDisabled)return;
  f.value='';pushMsg('me',t);const lvl=classify(t);
  if(lvl>=3){setTimeout(()=>aiRespondTo(t,lvl,false),300);return;}
  if(G){setTimeout(()=>guidedTurn(t),300);return;}
  setTimeout(()=>aiRespondTo(t,lvl,false),350);
}
/* ---- guided reflection flow ---- */
function startReflection(opening,followups,title,journeyId){
  G={followups:(followups&&followups.length)?followups:GENERIC_FOLLOWUPS,step:0,startIndex:S.chat.length,journeyId:journeyId||null};
  document.getElementById('chatOverlay').classList.add('open');
  document.getElementById('chatStatus').textContent=title||'guided reflection';
  applyAiState();setGuidedUI();
  pushMsg('ai',opening);
  document.getElementById('chatBody').scrollTop=1e6;
}
function startMode(id){const m=MODES.find(x=>x.id===id);if(!m)return;
  startReflection(m.opening.replace('{name}',S.name),m.followups,'Guided · '+m.title);}
function startJourney(id){const j=JOURNEYS.find(x=>x.id===id);if(!j)return;
  const done=(S.journeys&&S.journeys[id])||0;
  if(done>=j.steps.length){toast('You\'ve completed '+j.title+' 🎉');return;}
  startReflection(j.steps[done].replace('{name}',S.name),GENERIC_FOLLOWUPS,j.title+' · Day '+(done+1),id);}
function guidedTurn(text){
  let reply,act=null;
  if(G.step<G.followups.length){reply=G.followups[G.step];G.step++;}
  else{reply="Thank you for going there, "+S.name+". That's a genuine reflection — whenever you're ready, I can save it to your journal.";act='save';}
  typing(()=>{pushMsg('ai',reply,act);speak(reply);},reply);
}
function saveGuidedReflection(){
  if(!G){toast('Nothing to save');return;}
  const notes=S.chat.slice(G.startIndex).filter(m=>m.r==='me').map(m=>m.t);
  if(!notes.length){toast('Share a little first');return;}
  const text=notes.join('\n\n');const level=classify(text);
  const mood=level>=2?Math.min(detectMood(text),35):detectMood(text);
  S.entries.push({id:Date.now(),text,mood,ts:Date.now(),level});
  const jid=G.journeyId;
  const m=text.match(/(?:need to|have to|should|must|remember to)\s+([^.!?\n]{3,60})/i);
  if(m)S.tasks.push({id:Date.now()+1,text:cap(m[1].trim()),done:false});
  if(jid){S.journeys=S.journeys||{};S.journeys[jid]=(S.journeys[jid]||0)+1;}
  G=null;save();renderJournal();renderHome();setGuidedUI();
  document.getElementById('chatStatus').textContent='online';
  pushMsg('ai',"Saved to your journal ✓ You'll see it and your updated patterns in Insights.");
  toast('Reflection saved ✓');
  if(level>=3){S.aiDisabled=true;save();applyAiState();openCrisis();}
}
function detectMood(text){const low=text.toLowerCase();
  const pos=(low.match(/(great|good|proud|happy|calm|relieved|excited|grateful|better|win|love|glad|peaceful|content|enjoy)/g)||[]).length;
  const neg=(low.match(/(stress|anxious|tired|overwhelm|worried|sad|down|angry|frustrat|exhaust|drain|lonely|scared|hard|difficult|hate)/g)||[]).length;
  if(neg>pos+1)return 15;if(neg>pos)return 35;if(pos>neg+1)return 95;if(pos>neg)return 75;return 55;}
function askYourself(q){q=(q||'').trim();if(!q)return;openChat();pushMsg('me',q);
  const lvl=classify(q);setTimeout(()=>aiRespondTo(q,lvl,false),350);}

/* ---- ask your journal (dedicated Q&A over your entries) ---- */
const ASK_SUGGESTIONS=["What stresses me most?","When am I happiest?","How has my week been?","What keeps coming up lately?","What helps me feel better?"];
const ASK_STOP=['what','when','where','which','have','been','with','that','this','about','most','feel','feeling','feelings','lately','recently','journal','tell','does','make','makes','been','from'];
let askLog=[];
function retrieve(query){
  const low=query.toLowerCase();
  const wantsPos=/(happ|best|good|enjoy|love|grateful|proud|joy|calm|better|help)/.test(low)&&!/(not |un|less|stress|anx|worr|sad|down|bad)/.test(low);
  const wantsNeg=/(stress|anx|worr|sad|down|bad|hard|struggl|tough|drain|tired|overwhelm|upset|angry|frustrat|difficult)/.test(low);
  const words=(low.match(/[a-z]{4,}/g)||[]).filter(w=>!ASK_STOP.includes(w));
  const scored=S.entries.map(e=>{
    const t=e.text.toLowerCase();let score=0;
    words.forEach(w=>{if(t.includes(w))score+=THEME_WORDS.includes(w)?2:1;});
    if(wantsPos&&e.mood>=70)score+=2;
    if(wantsNeg&&e.mood<50)score+=2;
    return {e,score};
  }).sort((a,b)=>b.score-a.score||b.e.ts-a.e.ts);
  let hits=scored.filter(s=>s.score>0).map(s=>s.e);
  if(!hits.length){
    if(wantsPos)hits=S.entries.filter(e=>e.mood>=70).sort((a,b)=>b.mood-a.mood);
    else if(wantsNeg)hits=S.entries.filter(e=>e.mood<50).sort((a,b)=>b.ts-a.ts);
    else hits=S.entries.slice().sort((a,b)=>b.ts-a.ts);
  }
  return {hits:hits.slice(0,3),wantsPos,wantsNeg};
}
function askJournal(query){
  if(!S.entries.length)return{answer:"You haven't written any entries yet. Journal a little and I'll be able to answer questions about your patterns.",sources:[]};
  const {hits,wantsPos,wantsNeg}=retrieve(query);
  const themes=themeCounts().slice(0,2).map(t=>cap(t[0]));
  const th=themes.length?themes.join(' and '):'a few recurring themes';
  if(!hits.length)return{answer:"I couldn't find entries that speak to that yet. Try journaling about it, then ask me again.",sources:[]};
  let answer;
  if(wantsPos)answer="You seem to light up most around "+th.toLowerCase()+". "+(hits.length>1?"Here are a few moments":"Here's a moment")+" from your journal that stood out:";
  else if(wantsNeg)answer="Looking across your journal, this tends to cluster around "+th.toLowerCase()+". "+(hits.length>1?"These are the moments":"This is the moment")+" most connected to what you asked:";
  else answer=cap(th)+" come up most around this. Here's what I found in your entries:";
  return {answer,sources:hits};
}
function openAsk(prefill){
  document.getElementById('askOverlay').classList.add('open');renderAsk();
  if(prefill)setTimeout(()=>runAsk(prefill),280);
  else setTimeout(()=>{const i=document.getElementById('askInput');if(i)i.focus();},320);
}
function closeAsk(){document.getElementById('askOverlay').classList.remove('open');}
function runAskFromInput(){const f=document.getElementById('askInput');runAsk(f.value);f.value='';}
function runAsk(query){query=(query||'').trim();if(!query)return;
  if(classify(query)>=3){openCrisis();return;}
  askLog.push({q:query,pending:true});renderAsk();
  const sc=document.getElementById('askScroll');sc.scrollTop=sc.scrollHeight;
  setTimeout(()=>{const res=askJournal(query);const it=askLog[askLog.length-1];
    it.pending=false;it.a=res.answer;it.sources=res.sources;renderAsk();sc.scrollTop=sc.scrollHeight;},700);
}
function renderAsk(){
  const sc=document.getElementById('askScroll');if(!sc)return;
  if(!askLog.length){
    sc.innerHTML='<div class="ask-intro"><div class="ask-badge">🔎</div><h3>Ask anything about yourself</h3><p>I\'ll search your private journal and answer from your own entries — your patterns, moods, and moments.</p></div>'+
      '<div class="suggest-list">'+ASK_SUGGESTIONS.map(q=>'<div class="sg" onclick="runAsk('+JSON.stringify(q).replace(/"/g,'&quot;')+')"><span class="qic">✦</span>'+q+'<svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M9 6l6 6-6 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg></div>').join('')+'</div>'+
      '<div class="disclaimer" style="margin-top:16px">Reflection from your entries — not medical advice.</div>';
    return;
  }
  sc.innerHTML=askLog.map(it=>{
    let b='<div class="q-bubble">'+esc(it.q)+'</div>';
    if(it.pending)return b+'<div class="ask-typing"><i></i><i></i><i></i></div>';
    const src=it.sources.length?('<div class="a-src-label">Based on these entries</div>'+it.sources.map(e=>'<div class="src" onclick="closeAsk();go(\'journal\')"><span class="sdot" style="background:'+moodColor(e.mood)+'"></span><div class="sb"><h5>'+MOODS[e.mood]+' '+esc(titleFromText(e.text))+'</h5><p>'+esc(e.text)+'</p><div class="sw">'+fmtWhen(e.ts)+'</div></div></div>').join('')):'';
    return b+'<div class="a-card"><div class="a-tag">✦ From your journal</div><p>'+esc(it.a)+'</p>'+src+'</div>';
  }).join('')+'<div class="disclaimer">Reflection from your entries — not medical advice.</div>';
}
function aiRespondTo(userText,level,fromEntry){
  if(level>=3){pushMsg('ai',"I'm really glad you told me. What you're feeling matters, and you deserve real support right now — you don't have to hold this alone.");S.aiDisabled=true;save();applyAiState();setTimeout(openCrisis,600);return;}
  const reply=generateReply(userText,level,fromEntry);
  typing(()=>{pushMsg('ai',reply,level===2);speak(reply);},reply);
}
function generateReply(text,level,fromEntry){
  const low=text.toLowerCase();const p=persona();const name=S.name;
  // data query intent — only when actually asking about the past
  const isQuery = /^\s*(what|when|why|how|which|remember|recall|show me|tell me)\b/.test(low)
    || /\b(last week|last month|lately|recently|past few days|past week|have i been|was i|been feeling|my patterns|my mood)\b/.test(low);
  if(isQuery && /(stress|anxious|worried|mood|feel|down|sad|happ|week|going on|pattern|best|good|enjoy|love|grateful)/.test(low)){
    const themes=themeCounts().slice(0,2).map(t=>t[0]);
    const wantsPositive=/(happ|best|good|enjoy|love|grateful|proud|joy)/.test(low) && !/(not|un|less)/.test(low);
    if(wantsPositive){
      const pos=S.entries.filter(e=>e.mood>=70).sort((a,b)=>b.mood-a.mood);
      if(pos.length)return "From your journal, you seem to light up most around "+(themes.join(' and ')||'the good days')+". On "+fmtWhen(pos[0].ts).toLowerCase()+" you wrote: “"+titleFromText(pos[0].text)+"”. Want to build in more of that?";
      return "You haven't logged many high points yet — journal a good moment when it happens and I'll help you spot what creates them.";
    }
    const neg=S.entries.filter(e=>e.mood<50).sort((a,b)=>b.ts-a.ts).slice(0,3);
    if(neg.length){
      return "Looking back through your journal, the harder moments clustered around "+(themes.join(' and ')||'work')+". For example, on "+fmtWhen(neg[0].ts).toLowerCase()+" you wrote: “"+titleFromText(neg[0].text)+"”. Want to unpack what was underneath that?";
    }
    return "From what you've journaled, your week has actually leaned steady — no strong stress spikes stand out. What's prompting the question?";
  }
  // sentiment
  const positive=/(great|good|proud|happy|calm|relieved|excited|grateful|better|win|accomplished)/.test(low);
  const negative=/(stress|anxious|tired|overwhelm|worried|sad|down|angry|frustrat|can't|cant|exhaust|drain|lonely|scared)/.test(low);
  const openers={
    warm:["That makes a lot of sense.","Thank you for sharing that with me.","I hear you."],
    energetic:["Love that you're checking in.","Okay, let's channel this.","Good — awareness is step one."],
    structured:["Got it — let's make this concrete.","Noted. Let's break it down.","Right, let's get some clarity."],
    practical:["Okay, let's keep it simple.","That's useful to know.","Fair enough."],
    analytical:["Let's look at this objectively.","Noted — let's assess it.","Okay, stepping back."],
    patient:["Take your time with this.","That's a good place to start.","Let's work through it together."],
    strategic:["Let's think about this clearly.","Good to name it.","Okay, zooming out."]
  };
  const op=(openers[p.tone]||openers.warm);
  const opener=op[Math.floor(Math.random()*op.length)];
  let mid,q;
  if(level===2){
    return opener+" It sounds heavier than a normal rough patch, "+name+". You don't have to carry that alone — talking to someone you trust, or a professional, could really help. I'm still here with you in the meantime. What's weighing on you most?";
  }
  if(negative){
    const tips={warm:"What do you think is underneath it?",energetic:"What's one small thing that would take 5% off the load tonight?",structured:"If we pick just one piece to handle first, what should it be?",practical:"What would make the next hour a little easier?",analytical:"What's the actual risk here versus the worry about it?",patient:"What part feels the most tangled right now?",strategic:"What's the one lever that would change the most here?"};
    mid=" It's okay that today feels like this.";q=" "+(tips[p.tone]||tips.warm);
    return opener+mid+q;
  }
  if(positive){
    mid=" I'm genuinely glad — moments like this are worth noticing.";
    q=p.tone==='energetic'?" How do we repeat what made today work?":" What made the difference today, do you think?";
    return opener+mid+q;
  }
  // neutral / journaling
  const st=streak();
  q=fromEntry?" Thanks for writing that down — I've saved it. What's sitting with you most about it?":" Tell me a bit more — what's on your mind?";
  return opener+(st>1?" (That's day "+st+" of journaling, by the way.)":"")+q;
}

/* ============================ VOICE (Web Speech API) ============================ */
const SR=window.SpeechRecognition||window.webkitSpeechRecognition;
let rec=null,recTarget=null,recEl=null;
function voiceSupported(){return !!SR;}
function startRec(onText,el){
  if(!voiceSupported()){toast('Voice input needs Chrome/Safari with mic access');return false;}
  try{stopVoice();rec=new SR();rec.lang='en-IN';rec.interimResults=true;rec.continuous=false;
    recEl=el;if(el)el.classList.add('live');
    let final='';
    rec.onresult=e=>{let interim='';final='';for(let i=0;i<e.results.length;i++){const r=e.results[i];if(r.isFinal)final+=r[0].transcript;else interim+=r[0].transcript;}onText(final||interim,!!final);};
    rec.onerror=ev=>{toast(ev.error==='not-allowed'?'Microphone blocked — allow access':'Voice error: '+ev.error);stopVoice();};
    rec.onend=()=>{if(recEl)recEl.classList.remove('live');};
    rec.start();return true;
  }catch(e){toast('Could not start voice');return false;}
}
function stopVoice(){if(rec){try{rec.stop();}catch(e){}rec=null;}if(recEl){recEl.classList.remove('live');recEl=null;}
  document.getElementById('homeOrb')?.classList.remove('listening');}
function dictate(fieldId,el){
  const f=document.getElementById(fieldId);
  startRec((t)=>{f.value=t;},el);
}
function startChatVoice(){
  const el=document.getElementById('chatMic');
  const ok=startRec((t,fin)=>{document.getElementById('chatField').value=t;if(fin){setTimeout(sendMsg,300);}},el);
  if(ok)document.getElementById('chatStatus').textContent='listening…';
}
function quickVoice(){
  openChat();setTimeout(startChatVoice,350);
}
function speak(text){
  if(!S.settings.voice||!window.speechSynthesis)return;
  try{speechSynthesis.cancel();const u=new SpeechSynthesisUtterance(text.replace(/[\u{1F300}-\u{1FAFF}☀-➿]/gu,''));
    u.rate=1;u.pitch=1;u.lang='en-IN';speechSynthesis.speak(u);}catch(e){}
}

/* ============================ SHEETS ============================ */
let sheetMode=null;
function openSheet(mode){
  sheetMode=mode;const t=document.getElementById('sheetTitle'),s=document.getElementById('sheetSub'),
    f=document.getElementById('sheetFields'),btn=document.getElementById('sheetSave');
  if(mode==='braindump'){t.textContent='Brain dump';s.textContent='Empty your head — I\'ll save it and pull out anything actionable.';
    f.innerHTML='<textarea id="bdText" placeholder="Just start typing…"></textarea>';btn.textContent='Save to journal';btn.onclick=submitBraindump;}
  if(mode==='task'){t.textContent='New task';s.textContent='I\'ll keep it on your Home screen.';
    f.innerHTML='<input id="tkText" placeholder="e.g. Call the bank at 10am">';btn.textContent='Add task';btn.onclick=submitTask;}
  if(mode==='reminder'){t.textContent='New reminder';s.textContent='I\'ll nudge you at the right time.';
    f.innerHTML='<input id="remTime" placeholder="Time — e.g. 9:00 PM"><input id="remText" placeholder="What should I remind you?">';btn.textContent='Set reminder';btn.onclick=submitReminder;}
  if(mode==='log'){const k=kit();t.textContent=k.logTitle;s.textContent='Adds to your '+S.persona+' dashboard.';
    f.innerHTML='<input id="logWhat" placeholder="'+esc(k.fWhat.label)+' (e.g. '+esc(k.fWhat.ph)+')"><input id="logVal" inputmode="numeric" placeholder="'+esc(k.fVal.label)+' (e.g. '+esc(k.fVal.ph)+')">';btn.textContent=k.logVerb;btn.onclick=submitLog;}
  if(mode==='wipe'){t.textContent='Delete all data?';s.textContent='This erases every entry, task and chat on this device. It cannot be undone.';
    f.innerHTML='';btn.textContent='Yes, delete everything';btn.style.background='linear-gradient(135deg,#ff6b6b,#e0484d)';btn.onclick=confirmWipe;}
  else {document.getElementById('sheetSave').style.background='';}
  document.getElementById('sheetBack').classList.add('open');document.getElementById('sheet').classList.add('open');
  setTimeout(()=>{const el=f.querySelector('input,textarea');if(el)el.focus();},200);
}
function closeSheet(){document.getElementById('sheetBack').classList.remove('open');document.getElementById('sheet').classList.remove('open');}
function submitBraindump(){const v=document.getElementById('bdText').value.trim();if(!v){toast('Nothing to save');return;}
  document.getElementById('entryText').value=v;selMood=55;saveEntry(false);closeSheet();go('journal');}
function submitTask(){const v=document.getElementById('tkText').value.trim();if(!v){toast('Type a task');return;}
  S.tasks.push({id:Date.now(),text:v,done:false});save();renderHome();closeSheet();toast('Task added ✓');}
function confirmWipe(){S=fresh();S.consent=true;save();closeSheet();renderAll();go('home');toast('All data deleted');
  document.getElementById('sheetSave').style.background='';}

/* ============================ CRISIS ============================ */
function openCrisis(){document.getElementById('crisisTitle').textContent="You're not alone, "+S.name;
  document.getElementById('crisisOverlay').classList.add('open');}
function closeCrisis(){document.getElementById('crisisOverlay').classList.remove('open');}
function notifyContact(){toast('In the full app this alerts your trusted contact 💛');}

/* ============================ TOAST ============================ */
let toastT;function toast(msg){const el=document.getElementById('toast');el.textContent=msg;el.classList.add('show');
  clearTimeout(toastT);toastT=setTimeout(()=>el.classList.remove('show'),2400);}

/* ============================ CONSENT ============================ */
function acceptConsent(){S.consent=true;save();document.getElementById('consent').classList.add('hide');}

/* ============================ INIT ============================ */
function renderAll(){newQuip();renderChrome();renderHome();renderJournal();renderPersonas();renderSettings();}
renderAll();
if(S.consent)document.getElementById('consent').classList.add('hide');
setInterval(renderChrome,30000);
</script>
<script>
/* PWA: register the offline service worker */
if('serviceWorker' in navigator){
  window.addEventListener('load',function(){
    navigator.serviceWorker.register('sw.js').catch(function(){});
  });
}
