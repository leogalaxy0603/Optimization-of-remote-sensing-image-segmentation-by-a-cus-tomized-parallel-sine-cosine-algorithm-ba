%  Sine Cosine Algorithm (SCA)
%
%  Source codes demo version 1.0
%
%  Developed in MATLAB R2011b(7.13)
%
%  Author and programmer: Seyedali Mirjalili
%
%         e-Mail: ali.mirjalili@gmail.com
%                 seyedali.mirjalili@griffithuni.edu.au
%
%       Homepage: http://www.alimirjalili.com
%
%  Main paper:
%  S. Mirjalili, SCA: A Sine Cosine Algorithm for solving optimization problems
%  Knowledge-Based Systems, DOI: http://dx.doi.org/10.1016/j.knosys.2015.12.022
%_______________________________________________________________________________________________
% You can simply define your cost function in a seperate file and load its handle to fobj
% ��ֻ���ڵ������ļ��ж���ɱ����������������ص�fobj
% The initial parameters that you need are: ����Ҫ�ĳ�ʼ�����ǣ�
%__________________________________________
% fobj = @YourCostFunction
% dim = number of your variables ����������
% Max_iteration = maximum number of iterations ����������
% SearchAgents_no = number of search agents ����������
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n ����lbn�Ǳ���n���½�
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n ����ubn�Ǳ���n���Ͻ�
% If all the variables have equal lower bound you can just
% define lb and ub as two single numbers
% ������б������½綼��ȣ���ô���Խ�lb��ub����Ϊ��������������
% To run SCA: [Best_score,Best_pos,cg_curve]=SCA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj)
%______________________________________________________________________________________________

function [Destination_fitness,Destination_position,Convergence_curve]=SCA(N,Max_iteration,lb,ub,dim,fobj)

disp('SCA is optimizing your problem');

%Initialize the set of random solutions ��ʼ������⼯
X=initialization(N,dim,ub,lb);
Destination_position=zeros(1,dim);
Destination_fitness=inf;

Convergence_curve =zeros(1,Max_iteration);
Objective_values = zeros(1,size(X,1));

% Calculate the fitness of the first set and find the best one �����һ����ʺ϶Ȳ��ҳ���ѵ�һ��
for i=1:size(X,1) %size ��ȡ���������������,�ڶ������� 1Ϊ�У�2Ϊ��
    Objective_values(1,i)=fobj(X(i,:));
    if i==1
        Destination_position=X(i,:);
        %Destination_position Ŀ�ĵ�λ��
        Destination_fitness=Objective_values(1,i);
    elseif Objective_values(1,i)<Destination_fitness
        Destination_position=X(i,:);% ð�ţ�����ȫ������˼,ȡ��i�е�ȫ����
        %Destination_position Ŀ�ĵ�λ��
        Destination_fitness=Objective_values(1,i);
    end
    
    All_objective_values(1,i)=Objective_values(1,i); %#ok<*AGROW>
end

%disp(X);
%Main loop 
t=2; % start from the second iteration since the first iteration was dedicated to calculating the fitness
% �ӵڶ��ε�����ʼ����Ϊ��һ�ε���ר�����ڼ�����Ӧ��
while t<=Max_iteration
    
    % Eq. (3.4)
    a = 2;
    Max_iteration = Max_iteration;
    r1=a-t*((a)/Max_iteration); % r1 decreases linearly from a to 0  r1��a��0���Լ�С
    % Update the position of solutions with respect to destination  ����Ŀ�ĵظ��½��������λ��
    for i=1:size(X,1) % in i-th solution �ڵ�i�����������
        for j=1:size(X,2) % in j-th dimension �ڵ�jά
            
            % Update r2, r3, and r4 for E q. (3.3) ΪE q��3.3������r2��r3��r4
            r2=(2*pi)*rand();
            r3=2*rand;
            r4=rand();
            
            % Eq. (3.3)
            if r4<0.5
                % Eq. (3.1)
                X(i,j)= X(i,j)+(r1*sin(r2)*abs(r3*Destination_position(j)-X(i,j)));
            else
                % Eq. (3.2)
                X(i,j)= X(i,j)+(r1*cos(r2)*abs(r3*Destination_position(j)-X(i,j)));
            end
            
        end
    end
    
    for i=1:size(X,1)
        % Check if solutions go outside the search spaceand bring them back
        % ����������Ƿ񳬳�������Χ���������
        Flag4ub=X(i,:)>ub;
        Flag4lb=X(i,:)<lb;
        X(i,:)=(X(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        % Calculate the objective values ����Ŀ��ֵ
        Objective_values(1,i)=fobj(X(i,:));
        
        % Update the destination if there is a better solution ����и��õĽ�������������Ŀ��
        if Objective_values(1,i)<Destination_fitness
            Destination_position=X(i,:);
            Destination_fitness=Objective_values(1,i);
        end
    end
    
    Convergence_curve(t)=Destination_fitness;
    
    % Display the iteration and best optimum obtained so far
    % ��ʾ��ĿǰΪֹ�õ��ĵ��������Ž�
    if mod(t,50)==0
        display(['At iteration ', num2str(t), ' the optimum is ', num2str(Destination_fitness)]);
    end
    
    % Increase the iteration counter ���ӵ���������
    t=t+1;
end