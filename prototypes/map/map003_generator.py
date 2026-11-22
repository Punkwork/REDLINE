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
for s in range(1000):
    g=gen(s)
    if not g: bad+=1; continue
    rows,edges=g
    good=all(len(p)==16 and p[0]=="ICE" and p[15]=="BOSS" and p[8] in("ICE","MINIBOSS") and p.count("ICE")+ (p[8]=="MINIBOSS")==8 and sum(t not in("ICE","MINIBOSS","BOSS") for t in p)==7 for p in paths(rows,edges)) and all(3<=len(x)<=4 for x in rows[1:15])
    ok+=good; bad+= not good
print("valid maps", ok, "of 1000 (rejected", bad, ")")
rows,edges=gen(int(sys.argv[1]) if len(sys.argv)>1 else 3)
ab={"ICE":"ICE","MINIBOSS":"MINI","BOSS":"BOSS","SAFEHOUSE":"SAFE","UPLINK":"UPLK","DEAD DROP":"DROP","CONSOLE LAB":"LAB","SIGNAL":"SIG?"}
for i,row in enumerate(rows): print("%2d  "%(i+1)+"  ".join("%-5s"%ab[q["t"]] for q in row))
print("paths:",len(paths(rows,edges)))
