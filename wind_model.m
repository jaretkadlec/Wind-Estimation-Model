function dx = wind_model(t,x,Awa,Bwa,Cwa,Go,tv,uv,yv)
    
    u = interp1(tv,uv,t)';
    y = interp1(tv,yv,t)';
    
    dx = (Awa-Go*Cwa)*x + Bwa*u + Go*y;
end