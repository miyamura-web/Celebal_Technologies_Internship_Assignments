
Create table SubjectAllotments (StudentID varchar(20), SubjectID varchar(20), Is_valid bit);
Insert into SubjectAllotments values
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);


Create table SubjectRequest (StudentID varchar(20), SubjectID varchar(20));
Insert into SubjectRequest values
('159103036', 'PO1496');


-- Write the Stored Procedure

Create UpdateSubjectAllotments
as
begin
declare @StudentID varchar(20), @RequestedSubjectID varchar(20), @CurrentSubjectID varchar(20);

declare request_cursor cursor for
select StudentID, SubjectID from SubjectRequest;

open request_cursor;
fetch next from request_cursor into @StudentID, @RequestedSubjectID;

while @@fetch_status = 0
    begin
     -- Get current valid subject
    select @CurrentSubjectID = SubjectID from SubjectAllotments 
    where StudentID = @StudentID and Is_Valid = 1;

    -- Case 1: No previous allotment
    if @CurrentSubjectID is null
        begin
            insert into SubjectAllotments (StudentID, SubjectID, Is_Valid)
            values (@StudentID, @RequestedSubjectID, 1);
        end
    -- Case 2: Requested subject is different
    else if @RequestedSubjectID != @CurrentSubjectID
        begin
            -- Mark old as invalid
            update SubjectAllotments set Is_Valid = 0
            where StudentID = @StudentID and Is_Valid = 1;

            -- Insert new as valid
            insert into SubjectAllotments (StudentID, SubjectID, Is_Valid)
            values (@StudentID, @RequestedSubjectID, 1);
        end

        fetch next from request_cursor into @StudentID, @RequestedSubjectID;
    end

    close request_cursor;
    deallocate request_cursor;
end;



-- Execute the Stored Procedure
exec UpdateSubjectAllotments;


-- Verify Output
select * from SubjectAllotments
order by Is_valid desc;
