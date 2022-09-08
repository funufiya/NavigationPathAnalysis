%%%%%%Plot Full Path%%%%%%
load('P1-a.mat')
d=P1a(3:end,:);

distance_to_travel=2.5;

travelled_distance=0;
travelled_distances=zeros(8,1);
enable_distance_summation=false;
separated_path_id=0;
separated_pathes_row_index=1;
separated_pathes=zeros(1,3);
for i=2:length(d)
    %If object collides with object  '1' set travelled distance to
    %0 and enable calculation of travelled distance.
    if(d(i,6)==1)
        enable_distance_summation=true; 
        travelled_distance=0;
        separated_path_id=separated_path_id+1;
    end
    
    %If object hits invisible trigger marked as '2'
    %summation
    if(d(i,6)==2)
        enable_distance_summation=false; 
        travelled_distances(separated_path_id)=travelled_distance;
    end
    
    
    %If object colided with other object '1' and distance should be
    %calculated
    if(enable_distance_summation==true)
        % Coordinates of current and previous locations
        x1=d(i-1,4);
        x2=d(i,4);
        y1=d(i,5);
        y2=d(i-1,5);
        dx=x1-x2;
        dy=y1-y2;   
        %Calculate euclidean distance 
        travelled_distance_increment=sqrt(dx^2+dy^2);
        %Calculate cumulative sum of distance
        travelled_distance=travelled_distance+travelled_distance_increment;
        
        %Store coordinates separately in separated_pathes array along with their id         
        separated_pathes(separated_pathes_row_index,1)=x1;
        separated_pathes(separated_pathes_row_index,2)=y1;
        separated_pathes(separated_pathes_row_index,3)=separated_path_id;
        separated_pathes_row_index=separated_pathes_row_index+1;
        
        separated_pathes(separated_pathes_row_index,1)=x2;
        separated_pathes(separated_pathes_row_index,2)=y2;   
        separated_pathes(separated_pathes_row_index,3)=separated_path_id;
        
        
    end
    
    
end

full_x=d(:,4);
full_y=d(:,5);
plot(full_x,full_y,'black')





%%%%%%Display object names%%%%%%%
colors=['p','g','brown','c','m','blue','y','k'];
cmap=hsv(9);

objects=[{'Apple'},'Battery','bottle','Rope','Dice','Rocket','Duck','Rabbit'];
objects_x=[-0.02,-3.07,2.88,0.63,-2.20,2.06,1.91,-2.51];
objects_y=[3.03,0.00,0.36,-2.91,-2.01,2.19,-2.23,1.75];
for i=1:8
   text(objects_x(i), objects_y(i),objects(i));
end


%%% Plot Separate Paths %%%
linewidth=3;
for i=1:8    
    indices=find(separated_pathes(:,3)==i);
    separate_path=separated_pathes(indices,:);
    hold on
    if(i==8)
        plot(separate_path(:,1),separate_path(:,2),'Color','red','LineWidth',linewidth);
    else
        plot(separate_path(:,1),separate_path(:,2),'Color',cmap(i+1,:),'LineWidth',linewidth);  
    end
   
end


legend('Full Path','Apple','Battery','bottle','Rope','Dice','Rocket','Duck','Rabbit');

for i=1:8
    display(strcat((objects(i)),"--",num2str(travelled_distances(i))));
end