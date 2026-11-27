import random, sys
ROWS=16; OTHER=["SAFEHOUSE","UPLINK","DEAD DROP","CONSOLE LAB","SIGNAL"]
def gen(seed):
    r=random.Random(seed)
    # node: dict(type, ice=count of ICE passed in rows 2-8,10-15 incl. this node, links)
    rows=[[{"t":"ICE","c":0}]]
    for row in range(2,ROWS):
        n=r.randint(3,4)
        if row==9:
            cur=[{"t":"ICE","c":p["c"]} for p in rows[-1]] # placeholder, counts carried
        prev=rows[-1]
        counts=sorted({p["c"] for p in prev})
        remaining_after=  sum(1 for x in range(row+1,ROWS) if x!=9)
        nodes=[]
        for k in range(n):
            c=counts[k%len(counts)] if k<len(counts) else r.choice(counts)
            if row==9:
                nodes.append({"t":"MINIBOSS" if k==0 else "ICE","c":c}); continue
            need=6-c   # ICE still needed in rows 2-8,10-15
            can_ice = need>=1
            can_other = (need<=remaining_after)
            if can_ice and can_other: t="ICE" if r.random()<need/(need+ (remaining_after+1-need)) else "OTHER"
            else: t="ICE" if can_ice else "OTHER"
            nodes.append({"t":t,"c":c+(1 if t=="ICE" else 0)})
        r.shuffle(nodes)
        # links: a node links to next-row nodes whose incoming count matches its own count
        rows.append(nodes)
    rows.append([{"t":"BOSS","c":6}])
    # build edges: prev node p -> next node q allowed iff q's count before itself == p.c
    def before(q,row): return q["c"]-(1 if q["t"]=="ICE" and row not in (1,9,16) else 0)
    edges=[]
    for ri in range(len(rows)-1):
        nxt=rows[ri+1]; e=[]
        for p in rows[ri]:
            opts=[j for j,q in enumerate(nxt) if before(q,ri+2)==p["c"]]
            r.shuffle(opts); e.append(sorted(opts[:r.randint(2,3)] if len(opts)>1 else opts))
        # every next node needs an incoming link
        for j,q in enumerate(nxt):
            if not any(j in x for x in e):
                cand=[i for i,p in enumerate(rows[ri]) if p["c"]==before(q,ri+2)]
                if not cand: return None
                e[r.choice(cand)].append(j)
        edges.append(e)
    # assign OTHER types evenly at random
    others=[q for row in rows for q in row if q["t"]=="OTHER"]
    pool=(OTHER*20)[:len(others)]; r.shuffle(pool)
    for q,t in zip(others,pool): q["t"]=t
    return rows,edges
def paths(rows,edges):
    out=[]
    def walk(ri,i,acc):
        acc=acc+[rows[ri][i]["t"]]
        if ri==len(rows)-1: out.append(acc); return
        for j in edges[ri][i]: walk(ri+1,j,acc)
    walk(0,0,[]); return out
ok=bad=0
_V1_RUN = __name__=="__main__" and "--v5" not in sys.argv   # MAP-003f: import-safe; v1-v4 output unchanged
for s in (range(1000) if "--v2" not in sys.argv and _V1_RUN else []):
    g=gen(s)
    if not g: bad+=1; continue
    rows,edges=g
    good=all(len(p)==16 and p[0]=="ICE" and p[15]=="BOSS" and p[8] in("ICE","MINIBOSS") and p.count("ICE")+ (p[8]=="MINIBOSS")==8 and sum(t not in("ICE","MINIBOSS","BOSS") for t in p)==7 for p in paths(rows,edges)) and all(3<=len(x)<=4 for x in rows[1:15])
    ok+=good; bad+= not good
if _V1_RUN:
    print("valid maps", ok, "of 1000 (rejected", bad, ")")
    rows,edges=gen(int(sys.argv[1]) if len(sys.argv)>1 and sys.argv[1].isdigit() else 3)
ab={"ICE":"ICE","MINIBOSS":"MINI","BOSS":"BOSS","SAFEHOUSE":"SAFE","UPLINK":"UPLK","DEAD DROP":"DROP","CONSOLE LAB":"LAB","SIGNAL":"SIG?"}
if _V1_RUN:
    for i,row in enumerate(rows): print("%2d  "%(i+1)+"  ".join("%-5s"%ab[q["t"]] for q in row))
    print("paths:",len(paths(rows,edges)))

# --- MAP-003c v2: guarantees and loose spacing (designer, 2026-11-22) ---
# Every path: at least 3 SAFEHOUSE + UPLINK combined, with at least 1 of each.
# Loose spacing: no more than 4 ICE Nodes in a row and no more than 4 non-ICE Nodes in a row on any path.
SU=("SAFEHOUSE","UPLINK")
def path_stats(rows,edges):
    best=None
    for p in paths(rows,edges):
        s=p.count("SAFEHOUSE"); u=p.count("UPLINK")
        if s+u<3 or s<1 or u<1: return p
    return None
def runs_ok(p):
    run=0; last=None
    for t in p[1:15]:
        k="ICE" if t in("ICE","MINIBOSS") else "OTHER"
        run=run+1 if k==last else 1; last=k
        if run>4: return False
    return True
def gen2(seed):
    r=random.Random(seed+100000)
    g=gen(seed)
    if not g: return None
    rows,edges=g
    for _ in range(200):   # repair: turn other Nodes on a failing path into SAFEHOUSE / UPLINK
        bad=None
        def walk(ri,i,acc):
            nonlocal bad
            if bad: return
            acc=acc+[(ri,i)]
            if ri==len(rows)-1:
                ts=[rows[a][b]["t"] for a,b in acc]; s=ts.count("SAFEHOUSE"); u=ts.count("UPLINK")
                if s+u<3 or s<1 or u<1: bad=(acc,s,u)
                return
            for j in edges[ri][i]: walk(ri+1,j,acc)
        walk(0,0,[])
        if not bad: break
        acc,s,u=bad
        cand=[(a,b) for a,b in acc if rows[a][b]["t"] not in("ICE","MINIBOSS","BOSS")+SU]
        if not cand: return None
        a,b=r.choice(cand); rows[a][b]["t"]="SAFEHOUSE" if s<=u else "UPLINK"
    else: return None
    if not all(runs_ok(p) for p in paths(rows,edges)): return None
    return rows,edges
if __name__=="__main__" and "--v2" in sys.argv:
    ok=0; tries=0; seed=0; made=[]
    while ok<200:
        g=gen2(seed); seed+=1; tries+=1
        if g:
            ok+=1; made.append(g)
            for p in paths(*g):
                s=p.count("SAFEHOUSE"); u=p.count("UPLINK")
                assert p[0]=="ICE" and p[15]=="BOSS" and p[8] in("ICE","MINIBOSS") and p.count("ICE")+(p[8]=="MINIBOSS")==8 and s+u>=3 and s>=1 and u>=1 and runs_ok(p)
    print("v2: 200 valid maps from %d seeds (%.0f%% accepted); every path checked" % (tries, 100*200/tries))
    rows,edges=made[3]
    for i,row in enumerate(rows): print("%2d  "%(i+1)+"  ".join("%-5s"%ab[q["t"]] for q in row))
    print("paths:",len(paths(rows,edges)))

# --- MAP-003d v3: every path has at least 1 of each non-ICE Node type 3–8 (designer, 2026-11-22) ---
# Types: Black Market Uplink, Uplink with Clinic, DEAD DROP, Console Lab, SAFEHOUSE, SIGNAL UNCLEAR.
# 7 other Nodes per path: one of each type, plus one free slot. The Clinic counts as an Uplink, so the
# MAP-003c rule (3+ SAFEHOUSE + Uplink, 1+ each) holds automatically.
SIX=["UPLINK","CLINIC","DEAD DROP","CONSOLE LAB","SAFEHOUSE","SIGNAL"]
ab["CLINIC"]="CLNC"
def gen3(seed):
    r=random.Random(seed+200000)
    g=gen(seed)
    if not g: return None
    rows,edges=g
    others=[q for row in rows for q in row if q["t"] not in("ICE","MINIBOSS","BOSS")]
    pool=(SIX*10)[:len(others)]; r.shuffle(pool)
    for q,t in zip(others,pool): q["t"]=t
    for _ in range(400):
        bad=None
        def walk(ri,i,acc):
            nonlocal bad
            if bad: return
            acc=acc+[(ri,i)]
            if ri==len(rows)-1:
                ts=[rows[a][b]["t"] for a,b in acc]
                miss=[t for t in SIX if t not in ts]
                if miss: bad=(acc,ts,miss)
                return
            for j in edges[ri][i]: walk(ri+1,j,acc)
        walk(0,0,[])
        if not bad: break
        acc,ts,miss=bad
        cand=[(a,b) for a,b in acc if rows[a][b]["t"] in SIX and ts.count(rows[a][b]["t"])>1]
        if not cand: return None
        a,b=r.choice(cand); rows[a][b]["t"]=r.choice(miss)
    else: return None
    if not all(runs_ok(p) for p in paths(rows,edges)): return None
    return rows,edges
if __name__=="__main__" and "--v3" in sys.argv:
    ok=0; seed=0; made=[]
    while ok<200 and seed<20000:
        g=gen3(seed); seed+=1
        if g:
            ok+=1; made.append(g)
            for p in paths(*g):
                assert p[0]=="ICE" and p[15]=="BOSS" and p[8] in("ICE","MINIBOSS") and p.count("ICE")+(p[8]=="MINIBOSS")==8
                assert all(t in p for t in SIX) and runs_ok(p)
                s=p.count("SAFEHOUSE"); u=p.count("UPLINK")+p.count("CLINIC")
                assert s+u>=3 and s>=1 and u>=1
    print("v3: %d valid maps from %d seeds (%.0f%% accepted); every path checked" % (ok, seed, 100*ok/seed))
    rows,edges=made[0]
    for i,row in enumerate(rows): print("%2d  "%(i+1)+"  ".join("%-5s"%ab[q["t"]] for q in row))
    print("paths:",len(paths(rows,edges)))

# --- MAP-003e v4: Uplink and Clinic merged (designer, 2026-11-22) ---
# Five other Node types; every path has 1+ of each and 3+ SAFEHOUSE + UPLINK combined (2 free slots).
FIVE=["UPLINK","DEAD DROP","CONSOLE LAB","SAFEHOUSE","SIGNAL"]
def gen4(seed):
    r=random.Random(seed+300000)
    g=gen(seed)
    if not g: return None
    rows,edges=g
    others=[q for row in rows for q in row if q["t"] not in("ICE","MINIBOSS","BOSS")]
    pool=(FIVE*10)[:len(others)]; r.shuffle(pool)
    for q,t in zip(others,pool): q["t"]=t
    for _ in range(500):
        bad=None
        def walk(ri,i,acc):
            nonlocal bad
            if bad: return
            acc=acc+[(ri,i)]
            if ri==len(rows)-1:
                ts=[rows[a][b]["t"] for a,b in acc]
                miss=[t for t in FIVE if t not in ts]
                if not miss and ts.count("SAFEHOUSE")+ts.count("UPLINK")<3: miss=["SAFEHOUSE","UPLINK"]
                if miss: bad=(acc,ts,miss)
                return
            for j in edges[ri][i]: walk(ri+1,j,acc)
        walk(0,0,[])
        if not bad: break
        acc,ts,miss=bad
        su=ts.count("SAFEHOUSE")+ts.count("UPLINK")
        cand=[(a,b) for a,b in acc if rows[a][b]["t"] in FIVE and ts.count(rows[a][b]["t"])>1
              and not (rows[a][b]["t"] in("SAFEHOUSE","UPLINK") and su<=3)]
        if not cand: return None
        a,b=r.choice(cand); rows[a][b]["t"]=r.choice(miss)
    else: return None
    if not all(runs_ok(p) for p in paths(rows,edges)): return None
    return rows,edges
if __name__=="__main__" and "--v4" in sys.argv:
    ok=0; seed=0; made=[]
    while ok<200 and seed<20000:
        g=gen4(seed); seed+=1
        if g:
            ok+=1; made.append(g)
            for p in paths(*g):
                assert p[0]=="ICE" and p[15]=="BOSS" and p[8] in("ICE","MINIBOSS") and p.count("ICE")+(p[8]=="MINIBOSS")==8
                assert all(t in p for t in FIVE) and runs_ok(p) and p.count("SAFEHOUSE")+p.count("UPLINK")>=3
    print("v4: %d valid maps from %d seeds (%.0f%% accepted); every path checked" % (ok, seed, 100*ok/seed))
    rows,edges=made[0]
    for i,row in enumerate(rows): print("%2d  "%(i+1)+"  ".join("%-5s"%ab[q["t"]] for q in row))
    print("paths:",len(paths(rows,edges)))

# --- MAP-003f v5: Uplink distribution (designer, 2026-11-27) ---
# Every complete route: 16 Nodes; row 1 ICE; row 9 one MINIBOSS + standard ICE; row 16 BOSS; 3-4 Nodes per
# row 2-15; exactly 8 ICE (MINIBOSS counts) and 7 non-combat Nodes whose (UPLINK, SAFEHOUSE, DEAD DROP,
# CONSOLE LAB, SIGNAL) counts are one of V5_DISTRIBUTIONS; MAP-003c spacing (at most 4 ICE or 4 non-ICE Nodes
# in a row, rows 1-15). V4's repair-and-reject was replaced by construction (report: MAP003F_V5_REPORT.md):
#   1. skeleton: ICE/non-ICE layout built row by row. Each Node carries its ICE count (as v1-v4) and the
#      longest ICE / non-ICE run of any route reaching it; a link is made only if the merged state can still
#      be completed (_v5_feasible, an exact table), so no route can break the counts or the spacing and no
#      Node is left without a way forward;
#   2. types: exact backtracking search over non-combat Nodes in row order. Each Node keeps, over every route
#      reaching it, the minimum of each type count and the maximum Uplink count; a type is placed only if some
#      completion still satisfies every one of those routes (_v5_types_ok). Bounded by V5_LIMITS.
# Deterministic: one random.Random per seed, seeded with a string (independent of PYTHONHASHSEED).
# Failures are reported (status "failed" + reason + counters); constraints are never relaxed.
V5_TYPES=("UPLINK","SAFEHOUSE","DEAD DROP","CONSOLE LAB","SIGNAL")
V5_DISTRIBUTIONS=((3,1,1,1,1),(2,2,1,1,1),(2,1,2,1,1),(2,1,1,2,1),(2,1,1,1,2))
V5_ROWS=16; V5_MINI=8; V5_LAST=14      # row indices: row 9 = index 8, row 15 = index 14
V5_ICE_FREE=6; V5_OTHER=7; V5_MAX_RUN=4  # ICE in rows 2-8 and 10-15; non-combat per route; spacing
V5_WEIGHTS=(2.2,1.2,1.2,1.2,1.2)  # mean count per route over the five distributions
V5_LIMITS={"skeleton_attempts":40,"row_attempts":30,"type_attempts":4,"type_steps":5000}
_V5_FREE=[i for i in range(1,V5_LAST+1) if i!=V5_MINI]
def _v5_free_after(idx): return sum(1 for i in _V5_FREE if i>idx)
def _v5_kinds(idx): return ("ICE",) if idx==V5_MINI else ("ICE","OTHER")
def _v5_inc(idx,kind): return 1 if kind=="ICE" and idx!=V5_MINI else 0
def _v5_adv(mi,mo,kind): return (mi+1 if mi else 1,0) if kind=="ICE" else (0,mo+1 if mo else 1)
_v5_memo={}
def _v5_feasible(idx,c,mi,mo):
    """Can a Node at row index idx (ICE count c, longest ICE run mi / non-ICE run mo over its routes) be completed?"""
    key=(idx,c,mi,mo)
    if key in _v5_memo: return _v5_memo[key]
    if mi>V5_MAX_RUN or mo>V5_MAX_RUN or c>V5_ICE_FREE or V5_ICE_FREE-c>_v5_free_after(idx): ok=False
    elif idx==V5_LAST: ok=(c==V5_ICE_FREE)
    else: ok=any(_v5_feasible(idx+1,c+_v5_inc(idx+1,k),*_v5_adv(mi,mo,k)) for k in _v5_kinds(idx+1))
    _v5_memo[key]=ok; return ok
def _v5_row(r,prev,idx):
    kids=[]; links=[[] for _ in prev]
    def merged(p,q):
        mi,mo=_v5_adv(p["mi"],p["mo"],q["k"]); return max(q["mi"],mi),max(q["mo"],mo)
    def can_link(i,j):
        p,q=prev[i],kids[j]
        return j not in links[i] and q["c"]==p["c"]+_v5_inc(idx,q["k"]) and _v5_feasible(idx,q["c"],*merged(p,q))
    def link(i,j):
        q=kids[j]; q["mi"],q["mo"]=merged(prev[i],q); links[i].append(j)
    def new(i,k):
        p=prev[i]; kids.append({"k":k,"c":p["c"]+_v5_inc(idx,k),"mi":0,"mo":0}); link(i,len(kids)-1)
    def opts(i):
        p=prev[i]; return [k for k in _v5_kinds(idx) if _v5_feasible(idx,p["c"]+_v5_inc(idx,k),*_v5_adv(p["mi"],p["mo"],k))]
    order=list(range(len(prev))); r.shuffle(order)
    for i in order:                                  # every parent gets a child it can legally continue into
        ks=opts(i)
        if not ks: return None
        if len(ks)==2:                               # spread ICE like v1: P(ICE) = ICE still needed / rows left
            need=V5_ICE_FREE-prev[i]["c"]; left=_v5_free_after(idx-1)
            ks=["ICE","OTHER"] if r.random()<need/left else ["OTHER","ICE"]
        done=False
        for k in ks:
            ex=[j for j,q in enumerate(kids) if q["k"]==k and can_link(i,j)]
            if ex and (len(kids)>=4 or r.random()<0.5): link(i,r.choice(ex)); done=True; break
            if len(kids)<4: new(i,k); done=True; break
            if ex: link(i,r.choice(ex)); done=True; break
        if not done: return None
    target=r.randint(3,4)
    while len(kids)<target:                          # 3-4 Nodes per row
        i=r.randrange(len(prev)); new(i,r.choice(opts(i)))
    for i in order:                                  # branching: 2-3 choices where the rules allow
        want=r.randint(2,3); cand=list(range(len(kids))); r.shuffle(cand)
        for j in cand:
            if len(links[i])>=want: break
            if can_link(i,j): link(i,j)
    if idx==V5_MINI:                                 # one MINIBOSS; every route into it has an ICE alternative
        cand=list(range(len(kids))); r.shuffle(cand)
        for j in cand:
            ps=[i for i in range(len(prev)) if j in links[i]]
            for i in ps:
                if len(links[i])<2:
                    alt=[x for x in range(len(kids)) if x!=j and can_link(i,x)]
                    if alt: link(i,r.choice(alt))
            if all(len(links[i])>=2 for i in ps): kids[j]["mini"]=True; break
        else: return None
    for l in links: l.sort()
    return kids,links
def _v5_skeleton(r,limits,stats):
    rows=[[{"k":"ICE","c":0,"mi":1,"mo":0}]]; edges=[]
    for idx in range(1,V5_LAST+1):
        for _ in range(limits["row_attempts"]):
            res=_v5_row(r,rows[-1],idx)
            if res: break
            stats["row_retries"]+=1
        else: return None
        kids,links=res; rows.append(kids); edges.append(links)
    if any(q["c"]!=V5_ICE_FREE for q in rows[-1]): return None
    rows.append([{"k":"BOSS","c":V5_ICE_FREE,"mi":0,"mo":0}]); edges.append([[0] for _ in rows[-2]])
    return rows,edges
def _v5_types_ok(s,left):
    """s = (min UPLINK, max UPLINK, min SAFEHOUSE, min DEAD DROP, min CONSOLE LAB, min SIGNAL) over every route
    reaching the Node; left = non-combat Nodes still to come. True if one completion suits every such route."""
    lo_u=max(0,2-s[0]); hi_u=3-s[1]
    return lo_u<=hi_u and lo_u+sum(max(0,1-x) for x in s[2:])<=left
def _v5_types(r,rows,edges,limits,stats):
    par={(ri+1,j):[i for i in range(len(rows[ri])) if j in edges[ri][i]] for ri in range(len(rows)-1) for j in range(len(rows[ri+1]))}
    flat=[(ri,j) for ri in range(1,len(rows)) for j in range(len(rows[ri]))]
    S={(0,0):(0,0,0,0,0,0)}; NC={(0,0):0}; T={}; steps=[0]
    def base(ri,j):
        ps=[S[(ri-1,i)] for i in par[(ri,j)]]
        ncs={NC[(ri-1,i)] for i in par[(ri,j)]}
        assert len(ncs)==1, "skeleton invariant broken: parents disagree on non-combat count"
        return (min(p[0] for p in ps),max(p[1] for p in ps))+tuple(min(p[k] for p in ps) for k in range(2,6)),ncs.pop()
    def dfs(n):
        if n==len(flat): return True
        steps[0]+=1
        if steps[0]>limits["type_steps"]: return False
        ri,j=flat[n]; b,nc=base(ri,j); k=rows[ri][j]["k"]
        if k!="OTHER":
            if not _v5_types_ok(b,V5_OTHER-nc): return False
            S[(ri,j)]=b; NC[(ri,j)]=nc; return dfs(n+1)
        order=[]; pool=list(range(5))                 # weighted order: no positional bias (see report)
        while pool:
            x=r.random()*sum(V5_WEIGHTS[t] for t in pool)
            for t in pool:
                x-=V5_WEIGHTS[t]
                if x<0: break
            order.append(t); pool.remove(t)
        for t in order:
            s=list(b)
            if t==0: s[0]+=1; s[1]+=1
            else: s[t+1]+=1
            s=tuple(s)
            if _v5_types_ok(s,V5_OTHER-nc-1):
                S[(ri,j)]=s; NC[(ri,j)]=nc+1; T[(ri,j)]=V5_TYPES[t]
                if dfs(n+1): return True
                if steps[0]>limits["type_steps"]: return False   # hard stop: no further tries once over budget
        return False
    ok=dfs(0); stats["type_steps"]+=steps[0]
    if ok:
        for (ri,j),t in T.items(): rows[ri][j]["t"]=t
    return ok
def gen5(seed,limits=V5_LIMITS):
    """MAP-003f map for an integer seed. Returns dict(status "ok"|"failed", seed, rows, edges, stats, reason).
    rows/edges use the v1-v4 layout: rows[ri][i]["t"] is the Node type, edges[ri][i] the next-row indices."""
    r=random.Random("MAP-003f/V5/%d"%seed)
    stats={"skeleton_attempts":0,"row_retries":0,"type_attempts":0,"type_steps":0}
    for _ in range(limits["skeleton_attempts"]):
        stats["skeleton_attempts"]+=1
        sk=_v5_skeleton(r,limits,stats)
        if sk is None: continue
        rows,edges=sk
        for _ in range(limits["type_attempts"]):
            stats["type_attempts"]+=1
            if _v5_types(r,rows,edges,limits,stats):
                out=[]
                for ri,row in enumerate(rows):
                    out.append([])
                    for q in row:
                        t=q.get("t") or ("BOSS" if q["k"]=="BOSS" else "MINIBOSS" if q.get("mini") else "ICE")
                        out[-1].append({"t":t,"c":q["c"]})
                return {"status":"ok","seed":seed,"rows":out,"edges":edges,"stats":stats,"reason":None}
    return {"status":"failed","seed":seed,"rows":None,"edges":None,"stats":stats,
            "reason":"no valid map within limits %r (constraints not relaxed)"%(limits,)}
def v5_json(m):
    """Map as JSON-ready data. The MINIBOSS is a category only: identity and ability are chosen on entry (MINIBOSS-003)."""
    return {"version":"V5","decision":"MAP-003f","seed":m["seed"],
            "rows":[[{"id":"r%dn%d"%(ri+1,i),"type":q["t"],"next":["r%dn%d"%(ri+2,j) for j in (m["edges"][ri][i] if ri<len(m["edges"]) else [])]}
                     for i,q in enumerate(row)] for ri,row in enumerate(m["rows"])]}
def v5_render(m):
    a=dict(ab,SIGNAL="SIG?")
    lines=[]
    for ri,row in enumerate(m["rows"]):
        cells=["%d:%-5s"%(i,a[q["t"]]) for i,q in enumerate(row)]
        nxt="" if ri>=len(m["edges"]) else "   -> "+" ".join("%d>%s"%(i,",".join(map(str,e))) for i,e in enumerate(m["edges"][ri]))
        lines.append(("%2d  %s%s"%(ri+1,"  ".join(cells),nxt)).rstrip())
    return "\n".join(lines)
if __name__=="__main__" and "--v5" in sys.argv:
    import time
    t0=time.time(); ok=0; seed=0; made=[]
    while ok<200 and seed<20000:
        m=gen5(seed); seed+=1
        if m["status"]=="ok":
            ok+=1; made.append(m)
            for p in paths(m["rows"],m["edges"]):
                assert len(p)==16 and p[0]=="ICE" and p[15]=="BOSS" and p[8] in("ICE","MINIBOSS")
                assert p.count("ICE")+p.count("MINIBOSS")==8 and tuple(p.count(t) for t in V5_TYPES) in V5_DISTRIBUTIONS
                ks=["I" if t in("ICE","MINIBOSS") else "O" for t in p[:15]]   # spacing, rows 1-15
                assert all(len(set(ks[i:i+V5_MAX_RUN+1]))>1 for i in range(15-V5_MAX_RUN))
    print("v5: %d valid maps from %d seeds (%.0f%% accepted) in %.1fs; every path checked; full validation: validate_map003_v5.py"%(ok,seed,100*ok/seed,time.time()-t0))
    s=[int(x) for x in sys.argv[1:] if x.isdigit()]
    m=gen5(s[0]) if s else made[0]
    print("seed",m["seed"]); print(v5_render(m)); print("paths:",len(paths(m["rows"],m["edges"])))
