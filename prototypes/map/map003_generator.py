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
for s in (range(1000) if "--v2" not in sys.argv else []):
    g=gen(s)
    if not g: bad+=1; continue
    rows,edges=g
    good=all(len(p)==16 and p[0]=="ICE" and p[15]=="BOSS" and p[8] in("ICE","MINIBOSS") and p.count("ICE")+ (p[8]=="MINIBOSS")==8 and sum(t not in("ICE","MINIBOSS","BOSS") for t in p)==7 for p in paths(rows,edges)) and all(3<=len(x)<=4 for x in rows[1:15])
    ok+=good; bad+= not good
print("valid maps", ok, "of 1000 (rejected", bad, ")")
rows,edges=gen(int(sys.argv[1]) if len(sys.argv)>1 and sys.argv[1].isdigit() else 3)
ab={"ICE":"ICE","MINIBOSS":"MINI","BOSS":"BOSS","SAFEHOUSE":"SAFE","UPLINK":"UPLK","DEAD DROP":"DROP","CONSOLE LAB":"LAB","SIGNAL":"SIG?"}
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
