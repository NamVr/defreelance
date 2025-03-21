import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

actor Defreelance {
    type Job = {
        id: Text;
        title: Text;
        description: Text;
        employer: Principal;
        assignedTo: ?Principal;
        isCompleted: Bool;
        claimedBy: ?Text;
    };

    stable var jobCounter : Nat = 0;
    var jobs = HashMap.HashMap<Text, Job>(0, Text.equal, Text.hash);

    public func createJob(title: Text, description: Text) : async Text {
        let jobId = "job_" # Nat.toText(jobCounter);
        let newJob : Job = {
            id = jobId;
            title = title;
            description = description;
            employer = Principal.fromActor(Defreelance);
            assignedTo = null;
            isCompleted = false;
            claimedBy = null;
        };
        jobs.put(jobId, newJob);
        jobCounter += 1;
        return jobId;
    };

    public query func getJobs() : async [Job] {
      Iter.toArray(jobs.vals());
    };

    // Function to claim a job
    public func claimJob(title: Text, freelancer: Text) : async Bool {
        switch (jobs.get(title)) {
            case (?job) {
              /**
              id = jobId;
            title = title;
            description = description;
            employer = Principal.fromActor(Defreelance);
            assignedTo = null;
            isCompleted = false;
            claimedBy = ?freelancer
              **/
                let updatedJob = {id = job.id;
            title = job.title;
            description = job.description;
            employer = Principal.fromActor(Defreelance);
            assignedTo = null;
            isCompleted = false;
            claimedBy = ?freelancer};
                jobs.put(title, updatedJob);
                return true;
            };
            case null {
                return false; // Job not found
            };
        };
    };

    public func assignJob(jobId: Text, freelancer: Principal) : async Bool {
        switch (jobs.get(jobId)) {
            case (?job) {
                let updatedJob = { job with assignedTo = ?freelancer };
                jobs.put(jobId, updatedJob);
                return true;
            };
            case (_) return false;
        }
    };

    public func completeJob(jobId: Text) : async Bool {
        switch (jobs.get(jobId)) {
            case (?job) {
                let updatedJob = { job with isCompleted = true };
                jobs.put(jobId, updatedJob);
                return true;
            };
            case (_) return false;
        }
    };
};
