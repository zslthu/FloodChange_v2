function EClass = EventClass(EF, Thres)
% EF = [I_pd; I_pdmax3; I_pa; I_pa_pd; I_sw; I_sm; I_sm_pd; I_smmax3_pd]

% event feature
i_pd = EF(1);
i_pdmax3 = EF(2);
i_pa = EF(3);
i_pa_pd = EF(4);
i_sw = EF(5);
i_sm = EF(6);
i_sm_pd = EF(7);
i_smmax3_pd = EF(8);

% classify threshold
thres_i_pd = Thres(1);
thres_i_pdmax3 = Thres(2);
thres_i_pa = Thres(3);
thres_i_pa_pd = Thres(4);
thres_i_sw = Thres(5);
thres_i_sm = Thres(6);
thres_i_sm_pd = Thres(7);
thres_i_smmax3_pd = Thres(8);

thres_i_pd_2 = Thres(9);
thres_i_pdmax3_2 = Thres(10);

% % IRF & ESF
if i_sm < thres_i_sm
    if (i_pd > thres_i_pd || i_pdmax3 > thres_i_pdmax3) && ...
            ~(i_pa > thres_i_pa && (i_pa_pd > thres_i_pa_pd || i_sw > thres_i_sw))
        EClass = 1; % IRF
    else    
        EClass = 2; % ESF
    end
else
    % % SMF & RoSF
    if (i_sm_pd > thres_i_sm_pd || i_smmax3_pd > thres_i_smmax3_pd) && ...
            ~(i_pd > thres_i_pd_2 || i_pdmax3 > thres_i_pdmax3_2)
        EClass = 3; % SMF
    else
        EClass = 4; % RSF
    end
end